defmodule BzaarWeb.StoreControllerTest do
  use BzaarWeb.ConnCase
  use ExUnit.Case

  alias Bzaar.Store
  alias Bzaar.User
  alias Bzaar.Repo
  alias Bzaar.S3Uploader

  @valid_attrs %{active: true, description: "some content", email: "some content", logo: "some content", name: "some content"}
  @signin %{name: "foo", email: "foo@bar.com", surname: "bar", password: "foobar"}
  @invalid_attrs %{}

  @tag :logged_in
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, store_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  @tag :logged_in
  test "shows chosen resource", %{conn: conn} do
    store = Repo.insert! %Store{}
    conn = get conn, store_path(conn, :show, store)
    assert json_response(conn, 200)["data"] == %{"id" => store.id,
      "name" => store.name,
      "description" => store.description,
      "email" => store.email,
      "active" => store.active,
      "logo" => S3Uploader.get_access_bucket(store.logo),
      "user_id" => store.user_id}
  end

  @tag :logged_in
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, store_path(conn, :show, -1)
    end
  end

  @tag :logged_in
  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, store_path(conn, :create), store: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Store, @valid_attrs)
  end

  @tag :logged_in
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, store_path(conn, :create), store: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :logged_in
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    store = Repo.insert! %Store{}
    conn = put conn, store_path(conn, :update, store), store: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Store, @valid_attrs)
  end

  @tag :logged_in
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    store = Repo.insert! %Store{}
    conn = put conn, store_path(conn, :update, store), store: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @comment """
  Not implemented
  @tag :logged_in
  test "deletes chosen resource", %{conn: conn} do
    store = Repo.insert! %Store{}
    conn = delete conn, store_path(conn, :delete, store)
    assert response(conn, 204)
    refute Repo.get(Store, store.id)
  end
  """

end
