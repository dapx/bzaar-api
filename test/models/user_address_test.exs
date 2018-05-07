defmodule Bzaar.UserAddressTest do
  use Bzaar.ModelCase

  alias Bzaar.UserAddress

  @valid_attrs %{cep: 42, city: "some content", complement: "some content", name: "some content", number: 42, street: "some content", uf: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserAddress.changeset(%UserAddress{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserAddress.changeset(%UserAddress{}, @invalid_attrs)
    refute changeset.valid?
  end
end
