defmodule Bzaar.CreditCardTest do
  use Bzaar.ModelCase

  alias Bzaar.CreditCard

  @valid_attrs %{active: true, cvc: "some content", expire: "some content", name: "some content", number: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CreditCard.changeset(%CreditCard{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CreditCard.changeset(%CreditCard{}, @invalid_attrs)
    refute changeset.valid?
  end
end
