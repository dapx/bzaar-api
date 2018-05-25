defmodule Bzaar.ProductController do
  use Bzaar.Web, :controller

  alias Bzaar.{Product, ProductImage}
  import Ecto.Query

  def index(conn, _params) do
    images_query = from i in ProductImage, order_by: i.sequence
    products = Repo.all(from p in Product, preload: [
        :sizes,
        images: ^images_query
      ])
    render(conn, "index.json", products: products)
  end

  def show(conn, %{"id" => id}) do
    images_query = from i in ProductImage, order_by: i.sequence
    product = Product
      |> from()
      |> preload([:sizes, images: ^images_query])
      |> Repo.get!(id)
    render(conn, "show.json", product: product)
  end

end
