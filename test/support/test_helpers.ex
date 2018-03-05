defmodule Bzaar.TestHelpers do
  alias Bzaar.Repo
  use 	Bzaar.Web, :controller

  def insert_user(attrs \\ %{}) do
    user = Map.merge(%{
      name: "foo",
      surname: "baar" ,
      email: "foo@bar.com",
      password: "foobar"
    }, attrs)

    %Bzaar.User{}
    |> Bzaar.User.registration_changeset(user)
    |> Repo.insert!()
  end

  def api_sign_in(conn, user) do
    conn = Guardian.Plug.api_sign_in(conn, user)
    token = Guardian.Plug.current_token(conn)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")
  end
end