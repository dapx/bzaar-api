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
    new_conn = Guardian.Plug.api_sign_in(conn, user)
    token 	 = Guardian.Plug.current_token(new_conn)
    put_req_header(new_conn, "authorization", "Bearer #{token}")
    new_conn
  end
end