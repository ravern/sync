defmodule Sync.Sessions.Session do
  use GenServer
  alias Sync.Sessions.Session

  @enforce_keys [:deck, :slug]
  defstruct [:deck, :slug, :password, page: 0]

  @registry_name :session_process_registry

  def start_link(%{slug: slug, deck: deck} = session_params) do
    session = %Session{slug: slug, deck: deck, password: session_params[:password]}
    GenServer.start_link(__MODULE__, session, name: via_tuple(slug))
  end

  defp via_tuple(slug) do
    {:via, Registry, {@registry_name, slug}}
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def get_page(pid) do
    GenServer.call(pid, :get_page)
  end

  def increment_page(pid) do
    GenServer.cast(pid, :increment_page)
  end

  def decrement_page(pid) do
    GenServer.cast(pid, :decrement_page)
  end

  def handle_call(:get, _from, session) do
    {:reply, session, session}
  end

  def handle_call(:get_page, _from, session) do
    {:reply, session.page, session}
  end

  def handle_cast(:increment_page, session) do
    if session.page == length(session.deck.images) - 1 do
      {:noreply, session}
    else
      {:noreply, %{session | page: session.page + 1}}
    end
  end

  def handle_cast(:decrement_page, session) do
    if session.page == 0 do
      {:noreply, session}
    else
      {:noreply, %{session | page: session.page - 1}}
    end
  end
end
