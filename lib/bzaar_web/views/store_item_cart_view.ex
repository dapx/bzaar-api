defmodule BzaarWeb.StoreItemCartView do
  use Bzaar.Web, :view

  def render("index.json", %{store_item_cart: store_item_cart}) do
    %{data: render_many(store_item_cart, BzaarWeb.StoreItemCartView, "item_cart.json")}
  end

  def render("index_product.json", %{store_item_cart: store_item_cart}) do
    %{data: render_many(store_item_cart, BzaarWeb.StoreItemCartView, "item.json")}
  end

  def render("show.json", %{store_item_cart: store_item_cart}) do
    %{data: render_one(store_item_cart, BzaarWeb.StoreItemCartView, "item_cart.json")}
  end

  def render("item_cart.json", %{store_item_cart: store_item_cart}) do
    %{id: store_item_cart.id,
      user_id: store_item_cart.user_id,
      user_name: store_item_cart.user.name,
      size_name: store_item_cart.size_name,
      product_name: store_item_cart.product_name,
      product_image: store_item_cart.product_image,
      product_price: store_item_cart.size_price,
      quantity: store_item_cart.quantity,
      status: store_item_cart.status,
      address: store_item_cart.address,
      updated_at: store_item_cart.updated_at,
      inserted_at: store_item_cart.inserted_at
    }
  end

  def render("item.json", %{store_item_cart: store_item_cart}) do
    [%{url: url}|tail] = store_item_cart.size.product.images
    %{id: store_item_cart.id,
      user_id: store_item_cart.user_id,
      user_name: store_item_cart.user.name,
      product_id: store_item_cart.size.product.id,
      quantity: store_item_cart.quantity,
      status: store_item_cart.status,
      size_name: store_item_cart.size_name,
      product_name: store_item_cart.size.product.name,
      product_price: store_item_cart.size.price,
      product_image: url,
      address: store_item_cart.address,
      updated_at: store_item_cart.updated_at,
      inserted_at: store_item_cart.inserted_at
    }
  end
end
