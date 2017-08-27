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
      product_id: item_cart.product_id,
      quantity: item_cart.quantity,
      status: item_cart.status,
    }
  end

    def render("item.json", %{item_cart: item_cart}) do
    %{id: item_cart.id,
      user_id: item_cart.user_id,
      product_id: item_cart.product_id,
      quantity: item_cart.quantity,
      status: item_cart.status,
      product_name: item_cart.product.name
    }
  end
end
