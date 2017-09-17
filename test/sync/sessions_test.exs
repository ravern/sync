defmodule Sync.SessionsTest do
  use Sync.DataCase
  alias Sync.{Sessions, Decks}

  @deck_attrs %{"title" => "Valid title!", "images" => []}

  defp create_deck! do
    {:ok, deck} = Decks.create_deck(@deck_attrs)
    deck
  end

  @session_attrs %{slug: nil}

  defp start_session(deck, attrs \\ %{}) do
    attrs
    |> Enum.into(@session_attrs)
    |> Enum.into(%{deck: deck})
    |> Sessions.start_session()
  end

  @generated_slug_length 6

  describe "session creation" do
    test "generates a slug if none given" do
      deck = create_deck!()
      slug = start_session(deck)
      assert String.length(slug) == @generated_slug_length
    end

    test "uses user-inputted slug if given" do
      deck = create_deck!()
      slug = start_session(deck, %{slug: "test-slug-1"})
      assert slug == "test-slug-1"
    end

    test "generates a slug if duplicate is given" do
      deck = create_deck!()
      start_session(deck, %{slug: "test-slug-2"})
      slug = start_session(deck, %{slug: "test-slug-2"}) # Duplicate
      assert String.length(slug) == @generated_slug_length
    end
  end

  describe "finding a session" do
    test "is successful with valid slug" do
      deck = create_deck!()
      slug = start_session(deck)
      assert {:ok, _} = Sessions.find_session(slug)
    end

    test "is unsuccessful with invalid slug" do
      assert :error = Sessions.find_session("a")
    end
  end
end
