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
  scope "/bzaar", Bzaar do
    pipe_through :api

    scope "/auth" do
      post "/signup", UserController, :create
      post "/signin", SessionController, :signin
    end
    
    scope "/secured" do
      pipe_through :secured

      resources "/stores", StoreController, except: [:delete] do

        resources "/products", StoreProductController, except: [:delete] do
          resources "/product_images", ProductImageController, except: [:delete]
        end

        resources "/dispatchers", DispatcherController, except: [:delete]
      end

      resources "/credit_cards", CreditCardController, except: [:delete]
      resources "/products", ProductController, only: [:index, :show]
      resources "/item_cart", ItemCartController, except: [:delete]
    end

  end
end
