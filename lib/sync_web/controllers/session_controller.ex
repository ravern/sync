defmodule SyncWeb.SessionController do
  use SyncWeb, :controller
  alias Sync.{Sessions, Decks}

  plug :scrub_params, "deck" when action in [:create]

  def create(conn, %{"deck" => %{"slug" => slug, "password" => password}}) do
    deck = Decks.find_deck!(slug)
    if password == deck.password do
      Sessions.start_session(deck)
      redirect(conn, to: session_path(conn, :show, deck.slug))
    else
      conn
      |> put_flash(:error, "Wrong password!")
      |> redirect(to: deck_path(conn, :show, slug))
    end
  end

  def show(conn, %{"slug" => slug}) do
    if Sessions.session_exists?(slug) do
      render(conn, "show.html", slug: slug)
    else
      conn
      |> put_status(:not_found)
      |> render(SyncWeb.ErrorView, "404.html")
    end
  end
end
