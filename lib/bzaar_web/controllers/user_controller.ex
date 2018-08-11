defmodule BzaarWeb.UserController do
  use Bzaar.Web, :controller

  alias Bzaar.User
  import Facebook

  plug :validate_resource when action in [:update]

  def validate_resource(conn, _) do
    validate_resource_by_param(conn, conn.params["id"])
  end

  def validate_nested_resource(conn, _) do
    validate_resource_by_param(conn, conn.params["user_id"])
  end

  defp validate_resource_by_param(conn, parameter) do
    with %User{id: user_id} <- Guardian.Plug.current_resource(conn),
         conn_user_id <- String.to_integer(parameter),
         true <- user_id == conn_user_id
    do
      conn
    else
      _ -> show_error(conn, "User doesn't have this resource associated")
    end
  end

  defp show_error(conn, error) do
    conn
    |> put_status(403)
    |> render(BzaarWeb.ErrorView, "error.json", error: error)
    |> halt # Used to prevend Plug.Conn.AlreadySentError
  end

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} -> user
        |> Bzaar.Token.generate_new_account_token()
        |> Bzaar.Email.confirmation_email(user)
        |> Bzaar.Mailer.deliver_later
        conn
        |> put_status(:created)
        |> render("registered.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BzaarWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = User
    |> Repo.get!(id)
    |> Repo.preload([:address])
    render(conn, "show.json", user: user)
  end

  def show(conn, %{"email" => email}) do
    user = User
    |> Repo.get!(where: email)
    |> Repo.preload([:address])
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = User
    |> Repo.get!(id)
    |> Repo.preload([:address])
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BzaarWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def verify_email(conn, %{"token" => token}) do
    with {:ok, user_id} <- Bzaar.Token.verify_new_account_token(token),
         %User{active: false} = user <- Repo.get(User, user_id),
         updated_user <- user |> Bzaar.User.mark_as_verified() |> Repo.update!
    do
      render(conn, "verified.json", user: updated_user)
    else
      %User{active: true} -> 
        conn
        |> render(BzaarWeb.ErrorView, "error.json", error: "E-mail already confirmed.")
      _ ->
        conn
        |> render(BzaarWeb.ErrorView, "error.json", error: "The verification link is invalid.")
    end
  end

  def verify_email(conn, _) do
    # If there is no token in our params, tell the user they've provided
    # an invalid token or expired token
    conn
    |> put_status(401)
    |> render(BzaarWeb.ErrorView, "error.json", error: "The verification link is invalid.")
  end

  def confirm_email(conn, %{"user_id" => id}) do
    user = Repo.get!(User, id)
    user
    |> Bzaar.Token.generate_new_account_token()
    |> Bzaar.Email.confirmation_email(user)
    |> Bzaar.Mailer.deliver_later
    send_resp(conn, :no_content, "")
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
