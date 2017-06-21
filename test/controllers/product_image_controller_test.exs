defmodule Bzaar.ProductImageControllerTest do
  use Bzaar.ConnCase

  alias Bzaar.ProductImage
  @valid_attrs %{sequence: 42, url: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, product_image_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    product_image = Repo.insert! %ProductImage{}
    conn = get conn, product_image_path(conn, :show, product_image)
    assert json_response(conn, 200)["data"] == %{"id" => product_image.id,
      "url" => product_image.url,
      "sequence" => product_image.sequence,
      "product_id" => product_image.product_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, product_image_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, product_image_path(conn, :create), product_image: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ProductImage, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, product_image_path(conn, :create), product_image: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    product_image = Repo.insert! %ProductImage{}
    conn = put conn, product_image_path(conn, :update, product_image), product_image: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ProductImage, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    product_image = Repo.insert! %ProductImage{}
    conn = put conn, product_image_path(conn, :update, product_image), product_image: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    product_image = Repo.insert! %ProductImage{}
    conn = delete conn, product_image_path(conn, :delete, product_image)
    assert response(conn, 204)
    refute Repo.get(ProductImage, product_image.id)
  end
end
