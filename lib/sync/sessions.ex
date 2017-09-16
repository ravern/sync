defmodule Sync.Sessions do
  @moduledoc """
  Interface to interact with sessions
  """

  use Supervisor
  alias Sync.Sessions.{Slug, Session}

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
  def start_session(%{slug: user_slug} = user_session_params) do
    # Generate slug if user did not specify
    slug = Slug.validate(user_slug) || Slug.generate()
    session_params = %{user_session_params | slug: slug}

    if session_exists?(slug) do
      # Try again, with new generated slug
      start_session(session_params)
    else
      Supervisor.start_child(__MODULE__, [session_params])
      # Return the slug
      slug
    end
  end

  @doc """
  Returns a boolean whether a session with
  the specified slug exists
  """
  def session_exists?(slug) do
    case Registry.lookup(:session_process_registry, slug) do
      [] -> false
      _ -> true
    end
  end
end
