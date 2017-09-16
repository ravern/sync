defmodule Sync.Sessions.Session do
  use GenServer
  alias Sync.Sessions.Session

  @enforce_keys [:deck, :slug]
  defstruct [:deck, :slug, :password]

  @registry_name :session_process_registry

  def start_link(%{slug: slug, deck: deck} = session_params) do
    session = %Session{slug: slug, deck: deck, password: session_params[:password]}
    GenServer.start_link(__MODULE__, session, name: via_tuple(slug))
  end

  defp via_tuple(slug) do
    {:via, Registry, {@registry_name, slug}}
  end
end
