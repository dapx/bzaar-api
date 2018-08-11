defmodule BzaarWeb.UserAddressController do
  use Bzaar.Web, :controller

  alias Bzaar.{User, UserAddress}

  plug :validate_nested_resource when action in [:create, :edit, :upload, :delete, :index]

  def validate_nested_resource(conn, _) do
    with %User{id: user_id} <- Guardian.Plug.current_resource(conn),
         %{"user_id" => param_user_id} <- conn.params,
         true <- String.to_integer(param_user_id) == user_id
    do
      conn
    else
      _ -> conn
        |> put_status(403)
        |> render(BzaarWeb.ErrorView, "error.json", error: "User doesn't have this resource associated")
        |> halt # Used to prevend Plug.Conn.AlreadySentError
    end
  end

  def index(conn, _params) do
    user_address = Repo.all(UserAddress)
    render(conn, "index.json", user_address: user_address)
  end

  def create(conn, %{"user_id" => user_id, "user_address" => user_address_params}) do
    with user_id <- String.to_integer(user_id),
         changeset <- UserAddress.changeset(%UserAddress{user_id: user_id}, user_address_params),
         {:ok, user_address} <- Repo.insert(changeset)
    do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_user_address_path(conn, :show, user_address, user_id))
      |> render("show.json", user_address: user_address)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BzaarWeb.ChangesetView, "error.json", changeset: changeset)
      _ -> show_error(conn, "Unexpected error")
    end
  end

  def show(conn, %{"id" => id}) do
    user_address = Repo.get!(UserAddress, id)
    render(conn, "show.json", user_address: user_address)
  end

  def update(conn, %{"id" => id, "user_address" => user_address_params}) do
    with user_address when not is_nil(user_address) <- Repo.get(UserAddress, id),
         changeset <- UserAddress.changeset(user_address, user_address_params),
         {:ok, user_address} <- Repo.update(changeset)
    do
      conn 
      |> render("show.json", user_address: user_address)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BzaarWeb.ChangesetView, "error.json", changeset: changeset)
      nil -> show_error(conn, "Address does not exist.")
      _ -> show_error(conn, "Unexpected error")
    end
  end

  def delete(conn, %{"id" => id}) do
    user_address = Repo.get!(UserAddress, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user_address)

    send_resp(conn, :no_content, "")
  end

  defp show_error(conn, error) do
    conn
    |> put_status(403)
    |> render(BzaarWeb.ErrorView, "error.json", error: error)
    |> halt # Used to prevend Plug.Conn.AlreadySentError
  end
end
