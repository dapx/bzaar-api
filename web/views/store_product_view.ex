defmodule Bzaar.StoreProductView do
  use Bzaar.Web, :view

  def render("index.json", %{products: products}) do
    %{data: render_many(products, Bzaar.StoreProductView, "product.json", as: :product)}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, Bzaar.StoreProductView, "product.json", as: :product)}
  end

  def render("created.json", %{product: product}) do
    %{data: render_one(product, Bzaar.StoreProductView, "product_without_images.json", as: :product)}
  end

  def render("product_without_images.json", %{product: product}) do
    %{id: product.id,
      name: product.name,
      description: product.description,
      image: product.image,
      sizes: product.sizes,
      store_id: product.store_id}
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
