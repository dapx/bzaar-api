defmodule Bzaar.UserTest do
  use Bzaar.ModelCase

  alias Bzaar.User

  @valid_attrs %{active: true, email: "some content", image: "some content", name: "some content", password: "some content", surname: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
