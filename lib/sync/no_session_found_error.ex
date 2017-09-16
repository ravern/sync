defmodule Sync.NoSessionFoundError do
  defexception message: "No session found"

  def exception(opts) do
    slug = Keyword.fetch!(opts, :slug)

    %Sync.NoSessionFoundError{
      message: "No session found for the slug \"#{slug}\""
    }
  end
end

defimpl Plug.Exception, for: Sync.NoSessionFoundError do
  def status(_exception), do: 404
end
