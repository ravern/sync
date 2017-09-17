defmodule Sync.DecksTest do
  use Sync.DataCase
  alias Sync.Decks

  @valid_attrs %{"title" => "Valid title!", "images" => []}
  @invalid_attrs %{"title" => "", "images" => []}

  defp create_deck! do
    {:ok, deck} = Decks.create_deck(@valid_attrs)
    deck
  end

  describe "deck creation" do
    test "is successful with valid data" do
      assert {:ok, _} = Decks.create_deck(@valid_attrs)
    end

    test "is unsuccessful with invalid data" do
      assert {:error, _} = Decks.create_deck(@invalid_attrs)
    end
  end

  describe "finding a deck" do
    test "is successful when deck exists" do
      %{id: id} = create_deck!()
      assert Decks.find_deck!(id)
    end

    test "is unsuccessful when deck doesn't exists" do
      assert_raise Ecto.NoResultsError, fn->
        Decks.find_deck!(0)
      end
    end
  end
end
