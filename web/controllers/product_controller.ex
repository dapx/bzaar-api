defmodule Bzaar.ProductController do
  use Bzaar.Web, :controller

  alias Bzaar.Product
  import Ecto.Query

  def index(conn, _params) do
    products = Repo.all(from p in Product, preload: [:images])
    render(conn, "index.json", products: products)
  end

  def show(conn, %{"id" => id}) do
    product =
      from(Product)
        |> preload([:images, :sizes])
        |> Repo.get!(id)
    render(conn, "show.json", product: product)
  end

end
