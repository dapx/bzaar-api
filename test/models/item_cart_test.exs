defmodule Bzaar.ItemCartTest do
  use Bzaar.ModelCase

  alias Bzaar.ItemCart

  @valid_attrs %{quantity: 42, status: 42, product_id: 1, user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ItemCart.changeset(%ItemCart{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ItemCart.changeset(%ItemCart{}, @invalid_attrs)
    refute changeset.valid?
  end
end
