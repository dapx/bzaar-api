defmodule Bzaar.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Bzaar.Web, :controller
      use Bzaar.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: BzaarWeb

      alias Bzaar.Repo
      import Ecto
      import Ecto.Query

      import BzaarWeb.Router.Helpers
      import BzaarWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/bzaar_web/templates",
                        namespace: BzaarWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import BzaarWeb.Router.Helpers
      import BzaarWeb.ErrorHelpers
      import BzaarWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Bzaar.Repo
      import Ecto
      import Ecto.Query
      import BzaarWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
