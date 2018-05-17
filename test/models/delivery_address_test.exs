defmodule Bzaar.DeliveryAddressTest do
  use Bzaar.ModelCase

  alias Bzaar.DeliveryAddress

  @valid_attrs %{cep: 42, city: "some content", complement: "some content", name: "some content", number: 42, street: "some content", uf: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DeliveryAddress.changeset(%DeliveryAddress{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DeliveryAddress.changeset(%DeliveryAddress{}, @invalid_attrs)
    refute changeset.valid?
  end
end
