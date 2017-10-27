defmodule Bzaar.StoreController do
  use Bzaar.Web, :controller

  alias Bzaar.Store

  def index(conn, _params) do
    stores = Repo.all(Store)
    render(conn, "index.json", stores: stores)
  end

  def list(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    store_id = conn.params["store_id"]
    stores = Repo.all(from s in Store,
      where: s.user_id == ^user.id)
    render(conn, "index.json", stores: stores)
  end

  def create(conn, %{"store" => store_params}) do
    #user = Repo.get(Bzaar.User, user_id)
    user = Guardian.Plug.current_resource(conn)
    changeset = Store.changeset(%Store{ user_id: user.id }, store_params)
    
    case Repo.insert(changeset) do
      {:ok, store} ->
        conn
        |> put_status(:created)
        #|> put_resp_header("location", store_path(conn, :show, store))
        |> render("show.json", store: store)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    store = Repo.get!(Store, id)
    render(conn, "show.json", store: store)
  end

  def update(conn, %{"id" => id, "store" => store_params}) do
    store = Repo.get!(Store, id)
    changeset = Store.changeset(store, store_params)

    case Repo.update(changeset) do
      {:ok, store} ->
        render(conn, "show.json", store: store)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    store = Repo.get!(Store, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(store)

    send_resp(conn, :no_content, "")
  end

end
