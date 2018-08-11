defmodule BzaarWeb.SessionControllerTest do
  use BzaarWeb.ConnCase
  alias Bzaar.{User, Repo}

  @valid_attrs %{name: "foo", email: "foo@bar.com", surname: "bar", password: "foobar"}

  setup do  
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    Repo.insert changeset
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    #{:ok, jwt, full_claims} = Guardian.encode_and_sign(user)
    #{:ok, %{user: user, jwt: jst, claims: full_claims}}
  end

  test "Do login", %{conn: conn} do
    conn = (post conn, session_path(conn, :signin), @valid_attrs)
    #conn.resp_headers
    #[{"authorization", jwt}] = Enum.filter(conn.resp_headers, fn {k, v} -> k == "authorization" end)
    jwt = json_response(conn, 202)["jwt"]
    assert json_response(conn, 202)

  end

end