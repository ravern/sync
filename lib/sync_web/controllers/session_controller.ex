defmodule SyncWeb.SessionController do
  use SyncWeb, :controller
  alias Sync.{Sessions, Decks}

  plug :scrub_params, "deck" when action in [:create]

  def create(conn, %{"deck" => %{"id" => id, "slug" => slug} = deck_params}) do
    password = deck_params["password"]
    deck = Decks.find_deck!(id)

    if password == deck.password do
      slug = Sessions.start_session(%{slug: slug, deck: deck})
      redirect(conn, to: session_path(conn, :show, slug))
    else
      conn
      |> put_flash(:error, "Wrong password!")
      |> redirect(to: deck_path(conn, :show, deck))
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
