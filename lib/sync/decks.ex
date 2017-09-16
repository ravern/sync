defmodule Sync.Decks do
  @moduledoc """
  Interface for decks.
  """

  alias Ecto.Multi
  alias Sync.Repo
  alias Sync.Decks.{Deck, Image}

  def change_deck(deck \\ %Deck{}) do
    Deck.changeset(deck, %{})
  end

  @doc """
  Creates a new deck.
  """
  def create_deck(attrs) do
    deck_changeset = Deck.changeset(%Deck{}, attrs)

    multi = Multi.insert(Multi.new, :deck, deck_changeset)

    attrs["images"]
    |> Enum.with_index()
    |> Enum.reduce(multi, fn {image, idx}, multi->
         Multi.run(multi, "image#{idx}", fn %{deck: deck}->
           image_changeset =
             deck
             |> Ecto.build_assoc(:images)
             |> Image.changeset(%{image: image})

           Repo.insert(image_changeset)
         end)
       end)
    |> run_create_deck_transaction()
  end

  # Runs the transaction and handles the result
  defp run_create_deck_transaction(%Ecto.Multi{} = multi) do
    case Repo.transaction(multi) do
      {:ok, %{deck: deck}} -> {:ok, deck}
      {:error, :deck, changeset, _} -> {:error, changeset}
      _ -> {:error, :upload_error}
    end
  end

  @doc """
  Gets the deck with the specified id
  from the database.

  Raises Ecto.NoResultsError if not found
  """
  def find_deck!(id), do: Repo.get!(Deck, id)
end
