defmodule Bzaar.ProductController do
  use Bzaar.Web, :controller

  alias Bzaar.Product
  import Ecto.Query

  def index(conn, _params) do
    products = Repo.all(Product)
    render(conn, "index.json", products: products)
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    render(conn, "show.json", product: product)
  end

end
