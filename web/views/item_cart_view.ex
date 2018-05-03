defmodule Bzaar.ItemCartView do
  use Bzaar.Web, :view

  def render("index.json", %{item_cart: item_cart}) do
    %{data: render_many(item_cart, Bzaar.ItemCartView, "item_cart.json")}
  end

  def render("index_product.json", %{item_cart: item_cart}) do
    %{data: render_many(item_cart, Bzaar.ItemCartView, "item.json")}
  end

  def render("show.json", %{item_cart: item_cart}) do
    %{data: render_one(item_cart, Bzaar.ItemCartView, "item_cart.json")}
  end

  def render("item_cart.json", %{item_cart: item_cart}) do
    %{id: item_cart.id,
      user_id: item_cart.user_id,
      size_name: item_cart.size_name,
      product_name: item_cart.product_name,
      product_image: item_cart.product_image,
      product_price: item_cart.size_price,
      quantity: item_cart.quantity,
      status: item_cart.status,
      updated_at: item_cart.updated_at,
      inserted_at: item_cart.inserted_at,
    }
  end

  def render("item.json", %{item_cart: item_cart}) do
    [%{ url: url }|tail] = item_cart.size.product.images
    %{id: item_cart.id,
      user_id: item_cart.user_id,
      product_id: item_cart.size.product.id,
      quantity: item_cart.quantity,
      status: item_cart.status,
      size_name: item_cart.size_name,
      product_name: item_cart.size.product.name,
      product_price: item_cart.size.price,
      product_image: url,
      updated_at: item_cart.updated_at,
      inserted_at: item_cart.inserted_at,
    }
  end
end
