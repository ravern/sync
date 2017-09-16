defmodule Sync.Decks.Image do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Sync.Decks.{Deck, Image}

  schema "images" do
    field :image, SyncWeb.Image.Type

    belongs_to :deck, Deck

    timestamps()
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast_attachments(attrs, [:image])
    |> validate_required([:image])
  end
end

