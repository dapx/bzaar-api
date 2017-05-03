defmodule Bzaar.Router do
  use Bzaar.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession # looks in the session for the token
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :secured do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", Bzaar do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/bzaar/api", Bzaar do
    pipe_through :api
    post "/signup", UserController, :create
    post "/signin", SessionController, :signin
    
    scope "/stores" do
      pipe_through :secured
      post "/", StoreController, :create
      get "/:id", StoreController, :show
      get "/", StoreController, :index
    end
  end
end
