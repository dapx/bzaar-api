defmodule BzaarWeb.ProductControllerTest do
  use BzaarWeb.ConnCase

  alias Bzaar.Product
  @valid_attrs %{description: "some content", name: "some content", price: "120.5", quantity: 42, size: "some content"}
  @invalid_attrs %{}

  @tag :logged_in
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, product_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  @tag :logged_in
  test "shows chosen resource", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = get conn, product_path(conn, :show, product)
    assert json_response(conn, 200)["data"] == %{"id" => product.id,
      "name" => product.name,
      "description" => product.description,
      "price" => product.price,
      "quantity" => product.quantity,
      "size" => product.size,
      "store_id" => product.store_id,
      "image" => nil,
      "sizes" => [],
      "images" => []
    }
  end

  @tag :logged_in
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, product_path(conn, :show, -1)
    end
  end

end
