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
    get "/privacy_policy", PageController, :privacy
  end

  # Other scopes may use custom stacks.
  scope "/bzaar", Bzaar do
    pipe_through :api

    scope "/auth" do
      post "/signup", UserController, :create
      post "/signin", SessionController, :signin
      post "/facebook", SessionController, :signin_facebook
      post "/signup_facebook", UserController, :create_facebook
      get "/verify", UserController, :verify_email
    end
    
    scope "/secured" do
      pipe_through :secured

      resources "/stores", StoreController, except: [:delete] do
        resources "/store_address", StoreAddressController, except: [:new, :edit]
        resources "/item_cart", StoreItemCartController, only: [:index, :update]
        post "/upload_image", StoreController, :upload
        resources "/products", StoreProductController, except: [:delete] do
          resources "/product_images", ProductImageController, only: [:create, :update, :delete, :upload]
          # Upload product images
          post "/product_images/upload", ProductImageController, :upload

          # It will be deprecated soon
          # Upload product image default
          post "/product_image/upload", StoreProductController, :upload
        end

        resources "/dispatchers", DispatcherController, except: [:delete]
      end

      resources "/users", UserController, only: [:show, :update] do
        resources "/address", UserAddressController
        post "/send_confirmation", UserController, :confirm_email
      end

      get "/my_stores", StoreController, :list
      resources "/credit_cards", CreditCardController, except: [:delete]
      resources "/products", ProductController, only: [:index, :show]
      resources "/item_cart", ItemCartController
    end

  end
end
