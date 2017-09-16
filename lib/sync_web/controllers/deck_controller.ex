defmodule SyncWeb.DeckController do
  use SyncWeb, :controller
  alias Sync.{Sessions, Decks}

  plug :scrub_params, "deck" when action in [:secure_show]

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

  def show(conn, %{"id" => id}) do
    deck = Decks.find_deck!(id)
    if deck.password do
      redirect conn, to: deck_path(conn, :verify, deck_id: id)
    else
      render conn, "show.html", deck: deck, title: deck.title
    end
  end

  def secure_show(conn, %{"id" => id, "deck" => %{"password" => password}}) do
    deck = Decks.find_deck!(id)
    if password == deck.password do
      render conn, "show.html", deck: deck, title: deck.title, password: password
    else
      conn
      |> put_flash(:error, "Wrong password!")
      |> render("verify.html", deck_id: deck.id)
    end
  end

  def verify(conn, %{"deck_id" => id}) do
    render conn, "verify.html", deck_id: id
  end
end
