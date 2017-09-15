defmodule SyncWeb.DeckController do
  use SyncWeb, :controller
  alias Sync.{Sessions, Decks}

  plug :scrub_params, "deck" when action in [:verify]

  def new(conn, _params) do
    changeset = Decks.change_deck()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"deck" => deck_params}) do
    case Decks.create_deck(deck_params) do
      {:ok, deck} ->
        redirect conn, to: deck_path(conn, :show, deck)
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  # Preview the deck before "going live"
  def show(conn, %{"id" => id}) do
    deck = Decks.find_deck!(id)
    if deck.password do
      render conn, "enter_password.html", deck: deck, title: deck.title
    else
      render conn, "show.html", deck: deck, title: deck.title
    end
  end

  def verify(conn, %{"deck" => %{"id" => id, "password" => password}}) do
    deck = Decks.find_deck!(id)
    if password == deck.password do
      render conn, "show.html", deck: deck, title: deck.title, password: password
    else
      conn
      |> put_flash(:error, "Wrong password!")
      |> render("enter_password.html", deck: deck, title: deck.title)
    end
  end
end
