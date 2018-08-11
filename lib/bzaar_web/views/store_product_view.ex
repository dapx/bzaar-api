defmodule BzaarWeb.StoreProductView do
  use Bzaar.Web, :view

  def render("index.json", %{products: products}) do
    %{data: render_many(products, BzaarWeb.StoreProductView, "product.json", as: :product)}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, BzaarWeb.StoreProductView, "product.json", as: :product)}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      name: product.name,
      description: product.description,
      images: product.images,
      sizes: product.sizes,
      store_id: product.store_id}
  end

  def render("image.json", %{signed_url: signed_url, image_url: image_url, image_path: image_path}) do
    %{
      signed_url: signed_url,
      image_url: image_url,
      image_path: image_path
    }
  end
end
