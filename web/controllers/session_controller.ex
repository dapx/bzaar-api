defmodule Bzaar.SessionController do
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
        |> render("login.json", %{user: user, jwt: jwt, exp: exp})

        {:error, error} ->
        conn
        |> put_status(401)
        |> render(Bzaar.ErrorView, "error.json", error: error)
    end
  end

  def signin_facebook(conn, %{"access_token" => access_token}) do
    case Facebook.me("id,first_name,last_name,email,age_range,verified", access_token) do
      {:ok, facebook_user} ->
        case User.find_user_by_facebook_user_id(facebook_user["id"]) do
          {:ok, user} ->
            {new_conn, credentials} = authenticate(conn, user)
  
            new_conn
            |> put_status(202)
            # |> put_resp_header("authorization", "Bearer #{jwt}")
            # |> put_resp_header("x-expires", "%{exp}")
            |> render("login.json", credentials)

          {:error, _} ->
            new_params = generate_facebook_user(facebook_user)
            changeset = User.facebook_changeset(%User{}, new_params)
            case Repo.insert(changeset) do
              {:ok, user} ->
                {new_conn, credentials} = authenticate(conn, user)

                new_conn
                |> put_status(202)
                |> render("login.json", credentials)
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
            end
        end
      {:error, error} ->
        conn
        |> put_status(503)
        |> render(Bzaar.ErrorView, "error.json", error: error["message"])
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

  defp generate_facebook_user(user) do
    %{
      facebook_id: user["id"],
      name: user["first_name"],
      surname: user["last_name"],
      email: user["email"],
      active: user["verified"],
      password: :crypto.strong_rand_bytes(32) |> Base.encode64 |> binary_part(0, 32)
    }
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