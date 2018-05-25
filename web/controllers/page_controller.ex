defmodule Bzaar.PageController do
  use Bzaar.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def privacy(conn, _params) do
    render conn, "privacy-policy.html", subtitle: "Política de Privacidade"
  end
end
