defmodule Sync.Sessions do
  @moduledoc """
  Interface to interact with sessions
  """

  use Supervisor
  alias Sync.Sessions.Session

  ### Supervisor boilerplate ###
  def init(_) do
    supervise([worker(Sync.Sessions.Session, [])], strategy: :simple_one_for_one)
  end

  ### Client stuff ###
  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_session(deck) do
    Supervisor.start_child(__MODULE__, [deck])
  end

  def session_exists?(slug) do
    case Registry.lookup(:session_process_registry, slug) do
      [] -> false
      _ -> true
    end
  end
end
