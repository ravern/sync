defmodule Sync.SessionsTest do
  use Sync.DataCase
  alias Sync.{Sessions, Decks}

  @test_slug "test-slug"
  @invalid_slug "doesnt-exist"

  setup do
    deck = Decks.create_deck(%{
      title: "Test deck",
    })
    %{deck: deck}
  end

  describe "get_session/1" do
    test "returns session if found", %{deck: deck} do
      Sessions.start_session(%{deck: deck, slug: @test_slug})
      assert {:ok, _session} = Sessions.find_session(@test_slug)
    end

    test "returns error if not found" do
      assert :error = Sessions.find_session(@invalid_slug)
    end
  end
end
