defmodule Sync.Sessions.NoSessionFoundError do
  defexception message: "No session found"

  def exception(opts) do
    slug = Keyword.fetch!(opts, :slug)

    %Sync.Sessions.NoSessionFoundError{
      message: "No session found for the slug \"#{slug}\""
    }
  end
end

defimpl Plug.Exception, for: Sync.Sessions.NoSessionFoundError do
  def status(_exception), do: 404
end
