defmodule Bzaar.ProductController do
  use Bzaar.Web, :controller

  alias Bzaar.{Product, ProductImage, Size}
  import Ecto.Query

  def index(conn, %{"search" => search}) do
    images_query = from i in ProductImage, order_by: i.sequence
    sizes_query = from s in Size, order_by: [asc: s.price]
    products = Repo.all(
      from p in Product, preload: [
        sizes: ^sizes_query,
        images: ^images_query
      ],
      where: like(p.name, ^"%#{search}%") or
             like(p.description, ^"%#{search}%")
    )
    render(conn, "index.json", products: products)
  end

  def index(conn, _params) do
    images_query = from i in ProductImage, order_by: i.sequence
    sizes_query = from s in Size, order_by: [asc: s.price]
    products = Repo.all(from p in Product, preload: [
        sizes: ^sizes_query,
        images: ^images_query
      ])
    render(conn, "index.json", products: products)
  end

  def index(conn, %{"search" => search}) do
    images_query = from i in ProductImage, order_by: i.sequence
    sizes_query = from s in Size, order_by: [asc: s.price]
    products = Repo.all(
      from p in Product, preload: [
        sizes: ^sizes_query,
        images: ^images_query
      ],
      where: like(p.name, ^"%#{search}%") or
             like(p.description, ^"%#{search}%")
    )
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
