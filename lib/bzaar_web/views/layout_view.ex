defmodule BzaarWeb.LayoutView do
  use Bzaar.Web, :view

  def subtitle(conn) do
    case conn.assigns[:subtitle] do
      nil -> ""
      subtitle -> subtitle
    end
  end
end
