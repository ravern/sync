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
end
