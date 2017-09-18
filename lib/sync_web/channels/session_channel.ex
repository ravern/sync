defmodule SyncWeb.SessionChannel do
  use SyncWeb, :channel
  alias Sync.Sessions

  def join("session:" <> slug, _auth_message, socket) do
    socket = assign(socket, :slug, slug)
    {:ok, socket}
  end

  def handle_in("increment", _payload, socket) do
    slug = socket.assigns.slug
    Sessions.increment_session_page(slug)
    page = Sessions.find_session!(slug).page
    broadcast! socket, "page", %{value: page}
    {:noreply, socket}
  end

  def handle_in("decrement", _payload, socket) do
    slug = socket.assigns.slug
    Sessions.decrement_session_page(slug)
    page = Sessions.find_session!(slug).page
    broadcast! socket, "page", %{value: page}
    {:noreply, socket}
  end
end
