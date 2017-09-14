defmodule SyncWeb.DeckController do
  use SyncWeb, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
end
