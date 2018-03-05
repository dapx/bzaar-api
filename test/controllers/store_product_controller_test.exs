defmodule Bzaar.StoreProductControllerTest do
  use Bzaar.ConnCase

  alias Bzaar.Product
  import Bzaar.Factory

  @valid_sizes %{name: "some content", price: 120.5, quantity: 42}
  @valid_attrs %{description: "some content", name: "some content"}
  @valid_attrs_with_sizes %{description: "some content", name: "some content", sizes: [@valid_sizes]}
  @invalid_attrs %{}

  @tag :logged_in
  test "lists all entries on index", %{conn: conn} do
    store = insert(:store)
    store_id = store.id
    conn = get conn, store_store_product_path(conn, :index, store_id)
    assert json_response(conn, 200)["data"] == []
  end

  @tag :logged_in
  test "shows chosen resource", %{conn: conn} do
    store = insert(:store)
    store_id = store.id
    product = Repo.insert! %Product{store_id: store_id, sizes: [@valid_sizes], images: [%{url: "teste", sequence: 1}]}
    conn = get conn, store_store_product_path(conn, :show, product, product.id)
    assert json_response(conn, 200)["data"] == %{
      "id" => product.id,
      "name" => product.name,
      "description" => product.description,
      "store_id" => store_id,
      "images" => [%{"sequence" => 1, "url" => "teste"}],
      "sizes" => [%{"name" => "some content", "price" => 120.5, "quantity" => 42}]
    }
  end

  @tag :logged_in
  test "renders page not found when id is nonexistent", %{conn: conn} do
    store = insert(:store)
    store_id = store.id
    product = Repo.insert! %Product{store_id: store_id, sizes: [@valid_sizes]}
    assert_error_sent 404, fn ->
      get conn, store_store_product_path(conn, :show, -1, store_id)
    end
  end

  @tag :logged_in
  test "creates and renders resource when data is valid", %{conn: conn, user: user} do
    store = insert(:store, user: user)
    conn = post conn, store_store_product_path(conn, :create, store.id), product: @valid_attrs_with_sizes
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Product, @valid_attrs)
  end
  @comment """
  @tag :logged_in
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, store_store_product_path(conn, :create, @store_id), product: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :logged_in
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = put conn, store_store_product_path(conn, :update, product, @store_id), product: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Product, @valid_attrs)
  end

  @tag :logged_in
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = put conn, store_store_product_path(conn, :update, product, @store_id), product: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  
  Not implemented
  @tag :logged_in
  test "deletes chosen resource", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = delete conn, store_store_product_path(conn, :delete, product, @store_id)
    assert response(conn, 204)
    refute Repo.get(Product, product.id)
  end
  """
end
