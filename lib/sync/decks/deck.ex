defmodule Sync.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sync.Decks.Deck

  schema "decks" do
    field :title, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(%Deck{} = deck, attrs) do
    deck
    |> cast(attrs, [:title, :slug])
    |> validate_required([:title, :slug])
    |> unique_constraint(:slug)
  end
end
