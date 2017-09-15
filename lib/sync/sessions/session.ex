defmodule Sync.Sessions.Session do
  use GenServer

  @registry_name :session_process_registry

  def start_link(deck, slug) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(slug))
  end

  defp via_tuple(slug) do
    {:via, Registry, {@registry_name, slug}}
  end
end
