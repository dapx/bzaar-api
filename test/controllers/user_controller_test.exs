defmodule Bzaar.UserControllerTest do
  use Bzaar.ConnCase

  alias Bzaar.User
  @valid_attrs %{active: true, email: "some content", image: "some content", name: "some content", password: "some content", surname: "some content"}
  @signin %{name: "foo", email: "foo@bar.com", surname: "bar", password: "foobar"}
  @invalid_attrs %{}

  setup_all %{conn: conn} do
    changeset = User.registration_changeset(%User{}, @signin)
    Repo.insert changeset
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    conn = (post conn, session_path(conn, :signin), @signin)
    conn.resp_headers
    [{"authorization", jwt}] = Enum.filter(conn.resp_headers, fn {k, v} -> k == "authorization" end)
    {:ok, conn: put_req_header(conn, "authorization", "Bearer #{jwt}")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

end
