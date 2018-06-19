defmodule Bzaar.StoreAddressView do
  use Bzaar.Web, :view

  def render("index.json", %{store_address: store_address}) do
    %{data: render_many(store_address, Bzaar.StoreAddressView, "store_address.json")}
  end

  def render("show.json", %{store_address: store_address}) do
    %{data: render_one(store_address, Bzaar.StoreAddressView, "store_address.json")}
  end

  def render("store_address.json", %{store_address: store_address}) do
    %{id: store_address.id,
      name: store_address.name,
      cep: store_address.cep,
      uf: store_address.uf,
      city: store_address.city,
      street: store_address.street,
      number: store_address.number,
      complement: store_address.complement,
      latitude: store_address.latitude,
      longitude: store_address.longitude,
      store_id: store_address.store_id}
  end
end
