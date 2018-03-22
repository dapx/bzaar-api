defmodule Bzaar.ProductImageTest do
  use Bzaar.ModelCase

  alias Bzaar.ProductImage

  @valid_attrs %{sequence: 42, url: "some content", product_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProductImage.changeset(%ProductImage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProductImage.changeset(%ProductImage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
