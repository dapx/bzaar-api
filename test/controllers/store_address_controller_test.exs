defmodule Bzaar.StoreAddressControllerTest do
  use Bzaar.ConnCase

  alias Bzaar.StoreAddress
  @valid_attrs %{cep: 42, city: "some content", complement: "some content", latitude: "120.5", longitude: "120.5", name: "some content", number: 42, street: "some content", uf: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, store_address_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    store_address = Repo.insert! %StoreAddress{}
    conn = get conn, store_address_path(conn, :show, store_address)
    assert json_response(conn, 200)["data"] == %{"id" => store_address.id,
      "name" => store_address.name,
      "cep" => store_address.cep,
      "uf" => store_address.uf,
      "city" => store_address.city,
      "street" => store_address.street,
      "number" => store_address.number,
      "complement" => store_address.complement,
      "latitude" => store_address.latitude,
      "longitude" => store_address.longitude,
      "store_id" => store_address.store_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, store_address_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, store_address_path(conn, :create), store_address: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StoreAddress, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, store_address_path(conn, :create), store_address: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    store_address = Repo.insert! %StoreAddress{}
    conn = put conn, store_address_path(conn, :update, store_address), store_address: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StoreAddress, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    store_address = Repo.insert! %StoreAddress{}
    conn = put conn, store_address_path(conn, :update, store_address), store_address: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    store_address = Repo.insert! %StoreAddress{}
    conn = delete conn, store_address_path(conn, :delete, store_address)
    assert response(conn, 204)
    refute Repo.get(StoreAddress, store_address.id)
  end
end
