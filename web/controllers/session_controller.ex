defmodule Bzaar.SessionController do
  use Bzaar.Web, :controller
  alias Bzaar.User
  
  def signin(conn, params) do  
    %{"email" => email, "password" => password} = params
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
        |> render("login.json", %{user: user, jwt: jwt, exp: exp})

        {:error, error} ->
        conn
        |> put_status(401)
        |> render(Bzaar.ErrorView, "error.json", error: error)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:info, "You must be signed in to access this page")
    |> put_status(:forbidden)
    |> render(Bzaar.ErrorView, "error.json", %{ error: "unauthenticated"})
  end

  def unauthorized(conn, _params) do
    conn
    |> put_flash(:error, "You must be signed in to access this page")
    |> put_status(:unauthorized)
    |> render(Bzaar.ErrorView, "error.json", %{ error: "unauthorized"})
  end

end