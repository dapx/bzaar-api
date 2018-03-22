defmodule Bzaar.ProductTest do
  use Bzaar.ModelCase

  alias Bzaar.Product
  import Bzaar.Factory

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    store = insert(:store)
    changeset = Product.changeset(%Product{store_id: store.id}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
