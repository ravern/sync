defmodule Sync.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Sync.Repo, []),
      supervisor(SyncWeb.Endpoint, []),
      supervisor(Registry, [:unique, :session_process_registry]),
      supervisor(Sync.Sessions, []),
    ]

    opts = [strategy: :one_for_one, name: Sync.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    SyncWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
