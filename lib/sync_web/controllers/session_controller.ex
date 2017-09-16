defmodule SyncWeb.SessionController do
  use SyncWeb, :controller
  alias Sync.{Sessions, Decks}

  plug :scrub_params, "session" when action in [:create]
  plug :put_session when action in [:secure_show, :show]

  def create(conn, %{"session" => %{"deck_id" => deck_id, "password" => password, "slug" => slug} = session_params}) do
    deck_password = session_params["deck_password"]
    deck = Decks.find_deck!(deck_id)

    if deck_password == deck.password do
      slug = Sessions.start_session(%{slug: slug, deck: deck, password: password})
      redirect(conn, to: session_path(conn, :show, slug))
    else
      conn
      |> put_flash(:error, "Wrong password!")
      |> redirect(to: deck_path(conn, :verify, deck_id: deck_id))
    end
  end

  def show(conn, _params) do
    session = conn.assigns.session
    if session.password do
      redirect conn, to: session_path(conn, :verify, session_slug: session.slug)
    else
      render conn, "show.html", session: session, title: "LIVE: #{session.deck.title}"
    end
  end

  def secure_show(conn, %{"session" => %{"password" => password}}) do
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
