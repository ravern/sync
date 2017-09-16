defmodule Sync.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sync.Decks.{Image, Deck}

  schema "decks" do
    field :title, :string
    field :password, :string

    has_many :images, Image

    timestamps()
  end

  @doc false
  def changeset(%Deck{} = deck, attrs) do
    deck
    |> cast(attrs, [:title, :password])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
