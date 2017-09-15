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
        redirect conn, to: deck_path(conn, :show, deck.slug)
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  # Preview the deck before "going live"
  def show(conn, %{"slug" => slug}) do
    deck = Decks.find_deck!(slug)
    render conn, "show.html", deck: deck, title: deck.title
  end
end
