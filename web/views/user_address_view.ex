defmodule Bzaar.UserAddressView do
  use Bzaar.Web, :view

  def render("index.json", %{user_address: user_address}) do
    %{data: render_many(user_address, Bzaar.UserAddressView, "user_address.json")}
  end

  def render("show.json", %{user_address: user_address}) do
    %{data: render_one(user_address, Bzaar.UserAddressView, "user_address.json")}
  end

  def render("user_address.json", %{user_address: user_address}) do
    %{id: user_address.id,
      name: user_address.name,
      cep: user_address.cep,
      uf: user_address.uf,
      city: user_address.city,
      neighborhood: user_address.neighborhood,
      street: user_address.street,
      number: user_address.number,
      complement: user_address.complement,
      user_id: user_address.user_id}
  end
end
