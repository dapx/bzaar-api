defmodule Bzaar.ItemCartControllerTest do
  use Bzaar.ConnCase

  alias Bzaar.ItemCart
  @valid_attrs %{quantity: 42, status: 42, product_id: 1, user_id: 1}
  @invalid_attrs %{}

  @tag :logged_in
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_cart_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  @tag :logged_in
  test "shows chosen resource", %{conn: conn} do
    item_cart = Repo.insert! %ItemCart{}
    conn = get conn, item_cart_path(conn, :show, item_cart)
    assert json_response(conn, 200)["data"] == %{"id" => item_cart.id,
      "user_id" => item_cart.user_id,
      "product_id" => item_cart.product_id,
      "quantity" => item_cart.quantity,
      "status" => item_cart.status}
  end

  @tag :logged_in
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, item_cart_path(conn, :show, -1)
    end
  end

  @tag :logged_in
  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, item_cart_path(conn, :create), item_cart: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ItemCart, @valid_attrs)
  end

  @tag :logged_in
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, item_cart_path(conn, :create), item_cart: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :logged_in
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    item_cart = Repo.insert! %ItemCart{}
    conn = put conn, item_cart_path(conn, :update, item_cart), item_cart: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ItemCart, @valid_attrs)
  end

  @tag :logged_in
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    item_cart = Repo.insert! %ItemCart{}
    conn = put conn, item_cart_path(conn, :update, item_cart), item_cart: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :logged_in
  test "deletes chosen resource", %{conn: conn} do
    item_cart = Repo.insert! %ItemCart{}
    conn = delete conn, item_cart_path(conn, :delete, item_cart)
    assert response(conn, 204)
    refute Repo.get(ItemCart, item_cart.id)
  end
end
