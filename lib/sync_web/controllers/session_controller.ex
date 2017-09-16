defmodule SyncWeb.SessionController do
  use SyncWeb, :controller
  alias Sync.{Sessions, Decks}

  plug :scrub_params, "deck" when action in [:create]
  plug :put_session when action in [:secure_show, :show]

  def create(conn, %{"deck" => %{"id" => id, "slug" => slug} = deck_params}) do
    password = deck_params["password"]
    deck = Decks.find_deck!(id)

    if password == deck.password do
      slug = Sessions.start_session(%{slug: slug, deck: deck, password: password})
      redirect(conn, to: session_path(conn, :show, slug))
    else
      conn
      |> put_flash(:error, "Wrong password!")
      |> redirect(to: deck_path(conn, :show, deck.id))
    end
  end

  def show(conn, %{"slug" => slug}) do
    session = conn.assigns.session
    if session.password do
      redirect conn, to: session_path(conn, :verify, session_slug: session.slug)
    else
      render conn, "show.html", session: session, title: "LIVE: #{session.deck.title}"
    end
  end

  def secure_show(conn, %{"slug" => slug, "session" => %{"password" => password}}) do
    session = conn.assigns.session
    if password == session.password do
      render conn, "show.html", session: session, title: "LIVE: #{session.deck.title}"
    else
      conn
      |> put_flash(:error, "Wrong password!")
      |> render("verify.html", session_slug: session.slug)
    end
  end

  def verify(conn, %{"session_slug" => session_slug}) do
    render conn, "verify.html", session_slug: session_slug
  end

  defp put_session(conn, _opts) do
    session = Sessions.find_session!(conn.params["slug"])
    assign(conn, :session, session)
  end
end
