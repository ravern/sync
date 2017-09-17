defmodule SyncWeb.SessionControllerTest do
  use SyncWeb.ConnCase
  alias Sync.{Decks, Sessions}

  @deck_attrs %{"title" => "Valid title!", "images" => []}

  defp create_deck!(attrs \\ %{}) do
    {:ok, deck} =
      attrs
      |> Enum.into(@deck_attrs)
      |> Decks.create_deck()
    deck
  end

  @session_attrs %{slug: nil}

  defp start_session(deck, attrs \\ %{}) do
    attrs
    |> Enum.into(@session_attrs)
    |> Enum.into(%{deck: deck})
    |> Sessions.start_session()
  end

  test "visiting password-protected session redirects to verify page", %{conn: conn} do
    deck = create_deck!(%{"password" => "1234"})
    slug = start_session(deck, %{password: "1234"})
    conn = get(conn, session_path(conn, :show, slug))
    assert redirected_to(conn, 302) == session_path(conn, :verify, session_slug: slug)
  end

  test "entering valid password for protected session shows session slug", %{conn: conn} do
    deck = create_deck!()
    slug = start_session(deck, %{password: "1234"})
    conn = post(conn, session_path(conn, :secure_show, slug), %{"session" => %{"password" => "1234"}})
    assert html_response(conn, 200) =~ slug
  end

  test "entering invalid password for protected session shows error", %{conn: conn} do
    deck = create_deck!()
    slug = start_session(deck, %{password: "1234"})
    conn = post(conn, session_path(conn, :show, slug), %{"session" => %{"password" => ""}})
    assert html_response(conn, 200) =~ "Wrong"
  end
end
