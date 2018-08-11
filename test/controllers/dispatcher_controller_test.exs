defmodule BzaarWeb.DispatcherControllerTest do
  use BzaarWeb.ConnCase

  alias Bzaar.Dispatcher
  @valid_attrs %{company: "some content", distance_limit: 42, email: "some content", time_to_deliver: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, store_dispatcher_path(conn, :index, 1)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    dispatcher = Repo.insert! %Dispatcher{}
    conn = get conn, store_dispatcher_path(conn, :show, dispatcher)
    assert json_response(conn, 200)["data"] == %{"id" => dispatcher.id,
      "company" => dispatcher.company,
      "email" => dispatcher.email,
      "distance_limit" => dispatcher.distance_limit,
      "time_to_deliver" => dispatcher.time_to_deliver,
      "store_id" => dispatcher.store_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, store_dispatcher_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, store_dispatcher_path(conn, :create, 1), dispatcher: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Dispatcher, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, store_dispatcher_path(conn, :create, 1), dispatcher: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    dispatcher = Repo.insert! %Dispatcher{}
    conn = put conn, store_dispatcher_path(conn, :update, dispatcher, 1), dispatcher: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Dispatcher, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    dispatcher = Repo.insert! %Dispatcher{}
    conn = put conn, store_dispatcher_path(conn, :update, dispatcher, 1), dispatcher: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    dispatcher = Repo.insert! %Dispatcher{}
    conn = delete conn, store_dispatcher_path(conn, :delete, dispatcher, 1)
    assert response(conn, 204)
    refute Repo.get(Dispatcher, dispatcher.id)
  end
end
