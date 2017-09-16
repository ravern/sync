defmodule Sync.Decks do
  @moduledoc """
  Interface for decks.
  """

  alias Sync.Repo
  alias Sync.Decks.Deck

  def change_deck(deck \\ %Deck{}) do
    Deck.changeset(deck, %{})
  end

  @doc """
  Creates a new deck.
  """
  def create_deck(attrs) do
    %Deck{}
    |> Deck.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets the deck with the specified id
  from the database.

  Raises Ecto.NoResultsError if not found
  """
  def find_deck!(id), do: Repo.get!(Deck, id)
end
