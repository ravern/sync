defmodule Sync.Sessions do
  @moduledoc """
  Interface to interact with sessions
  """

  use Supervisor
  alias Sync.Sessions.{Slug, Session}

  @registry_name :session_process_registry

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    supervise([worker(Session, [])], strategy: :simple_one_for_one)
  end

  @doc """
  Starts a session using a user-specified slug,
  auto-generates a slug if it doesn't exist or
  if it isn't specified
  """
  def start_session(%{slug: user_slug} = session_params) do
    # Generate slug if user did not specify
    slug = Slug.validate(user_slug) || Slug.generate()

    case find_session(slug) do
      {:ok, _session} ->
        # Try again, with new generated slug
        start_session(%{session_params | slug: nil})
      :error ->
        Supervisor.start_child(__MODULE__, [%{session_params | slug: slug}])
        # Return the slug
        slug
    end
  end

  @doc """
  Returns `{:ok, session}` if exists or
  `{:error, :not_found}` if it doesn't
  """
  def find_session(slug) do
    case Registry.lookup(@registry_name, slug) do
      [{pid, _}] ->
        {:ok, Session.get(pid)}
      _ ->
        :error
    end
  end

  @doc """
  Same as `get_session/1`, but raises an
  error if not found
  """
  def find_session!(slug) do
    case find_session(slug) do
      {:ok, session} -> session
      :error -> raise Sync.NoSessionFoundError, slug: slug
    end
  end
end
