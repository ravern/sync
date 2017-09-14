defmodule Sync.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sync.Decks.Deck

  @slug_format ~r/[a-zA-Z_-]+/

  schema "decks" do
    field :title, :string
    field :slug, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(%Deck{} = deck, attrs) do
    deck
    |> cast(attrs, [:title, :slug, :password])
    |> validate_required([:title, :slug])
    |> validate_format(:slug, @slug_format)
    |> unique_constraint(:slug)
  end
end
