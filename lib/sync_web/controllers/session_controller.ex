defmodule SyncWeb.SessionController do
  use SyncWeb, :controller
  alias Sync.{Sessions, Decks}

  plug :scrub_params, "deck" when action in [:create]

  def create(conn, %{"deck" => %{"slug" => slug, "password" => password}}) do
    deck = Decks.find_deck!(slug)
    if password == deck.password do
      # Create the session
      Sessions.start_session(deck)

      # Redirect to the session url
      conn
      |> render("show.html")
    else
      conn
      |> put_flash(:error, "Wrong password!")
      |> redirect(to: deck_path(conn, :show, slug))
    end
  end

  def show(conn, %{"id" => id}) do

  end
end
