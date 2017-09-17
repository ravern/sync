defmodule SyncWeb.DeckControllerTest do
  use SyncWeb.ConnCase
  alias Sync.Decks

  @deck_attrs %{"title" => "Valid title!", "images" => []}

  defp create_deck!(attrs \\ %{}) do
    {:ok, deck} =
      attrs
      |> Enum.into(@deck_attrs)
      |> Decks.create_deck()
    deck
  end

  test "visiting password-protected deck redirects to verify page", %{conn: conn} do
    deck = create_deck!(%{"password" => "1234"})
    conn = get(conn, deck_path(conn, :show, deck))
    assert redirected_to(conn, 302) == deck_path(conn, :verify, deck_id: deck.id)
  end

  test "entering valid password for protected deck shows deck title", %{conn: conn} do
    deck = create_deck!(%{"password" => "1234"})
    conn = post(conn, deck_path(conn, :secure_show, deck), %{"deck" => %{"password" => "1234"}})
    assert html_response(conn, 200) =~ deck.title
  end

  test "entering invalid password for protected deck shows error", %{conn: conn} do
    deck = create_deck!(%{"password" => "1234"})
    conn = post(conn, deck_path(conn, :show, deck), %{"deck" => %{"password" => ""}})
    assert html_response(conn, 200) =~ "Wrong"
  end
end
