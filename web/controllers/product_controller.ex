defmodule Bzaar.ProductController do
  use Bzaar.Web, :controller

  alias Bzaar.Product
  import Ecto.Query

  def index(conn, _params) do
    products = Repo.all(from p in Product, preload: [:product_images])
    render(conn, "index.json", products: products)
  end

  def show(conn, %{"id" => id}) do
    product = Repo.one(from p in Product,
        where: p.id == ^id,
        preload: [:product_images])
    render(conn, "show.json", product: product)
  end

end
