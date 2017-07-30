defmodule Bzaar.StoreProductView do
  use Bzaar.Web, :view

  def render("index.json", %{products: products}) do
    %{data: render_many(products, Bzaar.StoreProductView, "product.json", as: :product)}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, Bzaar.StoreProductView, "product.json", as: :product)}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      quantity: product.quantity,
      size: product.size,
      store_id: product.store_id}
  end
end
