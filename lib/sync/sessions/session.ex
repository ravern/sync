defmodule Sync.Sessions.Session do
  use GenServer

  @registry_name :session_process_registry

  def start_link(deck) do
    # Namespace the name so won't collide with any existing name
    GenServer.start_link(__MODULE__, nil, name: via_tuple(deck.slug))
  end

  defp via_tuple(slug) do
    {:via, Registry, {@registry_name, slug}}
  end
end
