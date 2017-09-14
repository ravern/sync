defmodule SyncWeb.DeckController do
  use SyncWeb, :controller
  alias Sync.Decks

  def new(conn, _params) do
    changeset = Decks.change_deck()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"deck" => deck_params}) do
    case Decks.create_deck(deck_params) do
      {:ok, deck} ->
        redirect conn, to: deck_path(conn, :new)
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
