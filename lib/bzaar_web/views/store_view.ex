defmodule BzaarWeb.StoreView do
  use Bzaar.Web, :view
  alias Bzaar.S3Uploader

  def render("index.json", %{stores: stores}) do
    %{data: render_many(stores, BzaarWeb.StoreView, "store.json")}
  end

  def render("show.json", %{store: store}) do
    %{data: render_one(store, BzaarWeb.StoreView, "store.json")}
  end

  def render("store.json", %{store: store}) do
    %{id: store.id,
      name: store.name,
      description: store.description,
      email: store.email,
      active: store.active,
      logo: store.logo,
      user_id: store.user_id
    }
  end

  def render("image.json", %{signed_url: signed_url, image_url: image_url, image_path: image_path}) do
    %{
      signed_url: signed_url,
      image_url: image_url,
      image_path: image_path
    }
  end
end
