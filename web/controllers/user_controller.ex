defmodule Bzaar.UserController do
  use Bzaar.Web, :controller

  alias Bzaar.User
  import Facebook

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        Bzaar.Token.generate_new_account_token(user)
        |> Bzaar.Email.confirmation_email(user)
        |> Bzaar.Mailer.deliver_later
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def create_facebook(conn, %{"access_token" => access_token}) do
    case Facebook.me("id,first_name,last_name,email,age_range,verified", access_token) do
      {:ok, facebook_user} ->
        new_params = %{
          facebook_id: facebook_user["id"],
          name: facebook_user["first_name"],
          surname: facebook_user["last_name"],
          email: facebook_user["email"],
          active: facebook_user["verified"],
          password: :crypto.strong_rand_bytes(32) |> Base.encode64 |> binary_part(0, 32)
        }
        changeset = User.facebook_changeset(%User{}, new_params)
        case Repo.insert(changeset) do
          {:ok, user} ->
            conn
            |> put_status(:created)
            |> render("show.json", user: user)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
        end
      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ErrorView, "error.json", error: error)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def show(conn, %{"email" => email}) do
    user = Repo.get!(User, where: email)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    |> Repo.preload([:address])
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def verify_email(conn, %{"token" => token}) do
    with { :ok, user_id } <- Bzaar.Token.verify_new_account_token(token),
         %User{ active: false } = user <- Repo.get(User, user_id),
         updated_user <- Bzaar.User.mark_as_verified(user) |> Repo.update!
    do
      render(conn, "verified.json", user: updated_user);
    else
      %User{ active: true } -> 
        conn
        |> render(Bzaar.ErrorView, "error.json", error: "E-mail already confirmed.");
      _ ->
        conn
        |> render(Bzaar.ErrorView, "error.json", error: "The verification link is invalid.");
    end
  end

  def verify_email(conn, _) do
    # If there is no token in our params, tell the user they've provided
    # an invalid token or expired token
    conn
    |> put_status(401)
    |> render(Bzaar.ErrorView, "error.json", error: "The verification link is invalid.")
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
