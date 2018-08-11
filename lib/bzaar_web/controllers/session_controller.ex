defmodule BzaarWeb.SessionController do
  use Bzaar.Web, :controller
  alias Bzaar.User

  def signin(conn, %{"email" => email, "password" => password}) do  
    case User.find_and_confirm_password(email, password) do
        {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        claims = Guardian.Plug.claims(new_conn)
        exp = case claims do
            {:ok, result} -> Map.get(result, "exp")
        end

        new_conn
        |> put_status(202)
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "%{exp}")
        |> render(BzaarWeb.SessionView, "show.json", %{session: %{user: user, jwt: jwt, exp: exp}})

        {:error, error} ->
        conn
        |> put_status(401)
        |> render(BzaarWeb.ErrorView, "error.json", error: error)
    end
  end

  def signin_facebook(conn, %{"access_token" => access_token}) do
    with {:ok, facebook_user} <- Facebook.me("id,first_name,last_name,email,age_range,verified", access_token),
         {:ok, user} <- User.find_or_register_facebook_user(facebook_user),
         {new_conn, credentials} = authenticate(conn, user)
    do
      new_conn
      |> put_status(202)
      # |> put_resp_header("authorization", "Bearer #{jwt}")
      # |> put_resp_header("x-expires", "%{exp}")
      |> render(BzaarWeb.SessionView, "show.json", %{session: credentials})
    else
      {:error, error} ->
        conn
        |> put_status(503)
        |> render(BzaarWeb.ErrorView, "error.json", error: error["message"])
    end
  end

  defp authenticate(conn, user) do
    new_conn = Guardian.Plug.api_sign_in(conn, user)
    jwt = Guardian.Plug.current_token(new_conn)
    claims = Guardian.Plug.claims(new_conn)
    exp = case claims do
        {:ok, result} -> Map.get(result, "exp")
    end
    credentials = %{user: user, jwt: jwt, exp: exp}
    {new_conn, credentials}
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:info, "You must be signed in to access this page")
    |> put_status(:forbidden)
    |> render(BzaarWeb.ErrorView, "error.json", %{error: "unauthenticated"})
  end

  def unauthorized(conn, _params) do
    conn
    |> put_flash(:error, "You must be signed in to access this page")
    |> put_status(:unauthorized)
    |> render(BzaarWeb.ErrorView, "error.json", %{error: "unauthorized"})
  end

end