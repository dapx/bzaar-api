defmodule Bzaar.SizeTest do
  use Bzaar.ModelCase

  alias Bzaar.Size

  @valid_attrs %{name: "some content", price: 120.5, quantity: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Size.changeset(%Size{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Size.changeset(%Size{}, @invalid_attrs)
    refute changeset.valid?
  end
end
