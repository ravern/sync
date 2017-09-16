defmodule Sync.SessionsTest do
  use Sync.DataCase
  alias Sync.{Sessions, Decks}

  describe "session_exists?/1" do
    setup do
      deck = Decks.create_deck(%{
        title: "Test deck"
      })

      %{deck: deck}
    end
    
    @slug "test-slug"
    test "returns true when session exists", %{deck: deck} do
      Sessions.start_session(%{deck: deck, slug: @slug})
      assert Sessions.session_exists?(@slug) == true
    end

    test "returns false when sessions doesn't exist" do
      assert Sessions.session_exists?("doesnt-exist") == false
    end
  end
end
