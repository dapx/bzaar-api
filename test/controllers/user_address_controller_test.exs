defmodule Bzaar.UserAddressControllerTest do
  use Bzaar.ConnCase

  alias Bzaar.UserAddress
  @valid_attrs %{cep: 42, city: "some content", complement: "some content", name: "some content", number: 42, street: "some content", uf: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_address_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user_address = Repo.insert! %UserAddress{}
    conn = get conn, user_address_path(conn, :show, user_address)
    assert json_response(conn, 200)["data"] == %{"id" => user_address.id,
      "name" => user_address.name,
      "cep" => user_address.cep,
      "uf" => user_address.uf,
      "city" => user_address.city,
      "street" => user_address.street,
      "number" => user_address.number,
      "complement" => user_address.complement,
      "user_id" => user_address.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_address_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_address_path(conn, :create), user_address: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UserAddress, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_address_path(conn, :create), user_address: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user_address = Repo.insert! %UserAddress{}
    conn = put conn, user_address_path(conn, :update, user_address), user_address: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UserAddress, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_address = Repo.insert! %UserAddress{}
    conn = put conn, user_address_path(conn, :update, user_address), user_address: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user_address = Repo.insert! %UserAddress{}
    conn = delete conn, user_address_path(conn, :delete, user_address)
    assert response(conn, 204)
    refute Repo.get(UserAddress, user_address.id)
  end
end
