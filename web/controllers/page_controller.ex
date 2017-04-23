defmodule Bzaar.PageController do
  use Bzaar.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
