defmodule SyncWeb.Router do
  use SyncWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SyncWeb do
    pipe_through :browser # Use the default browser stack

    resources "/sessions", SessionController, only: [:create]
    get "/:slug", SessionController, :show
    resources "/decks", DeckController, only: [:create, :show], param: "slug"
    get "/", DeckController, :new
  end
end
