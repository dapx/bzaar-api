defmodule Bzaar.ProductView do
  use Bzaar.Web, :view

  def render("index.json", %{products: products}) do
    %{data: render_many(products, Bzaar.ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, Bzaar.ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      name: product.name,
      description: product.description,
      image: product.image,
      images: product.product_images,
      sizes: product.sizes,
      store_id: product.store_id}
  end
end
