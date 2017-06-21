defmodule Bzaar.DispatcherTest do
  use Bzaar.ModelCase

  alias Bzaar.Dispatcher

  @valid_attrs %{company: "some content", distance_limit: 42, email: "some content", time_to_deliver: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Dispatcher.changeset(%Dispatcher{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Dispatcher.changeset(%Dispatcher{}, @invalid_attrs)
    refute changeset.valid?
  end
end
