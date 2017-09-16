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

    get "/", DeckController, :new
    get "/decks/verify", DeckController, :verify
    post "/decks/:id", DeckController, :secure_show
    resources "/decks", DeckController, only: [:create, :show]

    resources "/sessions", SessionController, only: [:create]
    get "/sessions/verify", SessionController, :verify
    post "/:slug", SessionController, :secure_show
    get "/:slug", SessionController, :show
  end
end
