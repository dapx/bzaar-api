defmodule Bzaar.StoreController do
  use Bzaar.Web, :controller

  alias Bzaar.Store
  alias Bzaar.S3Uploader

  plug :validate_nested_resource when action in [:upload]

  def validate_nested_resource(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    store_id = conn.params["store_id"]
    store = Repo.one(from s in Store, where: s.id == ^store_id and s.user_id == ^user.id)

    case store do
      %Store{} -> conn
      _ -> conn
        |> put_status(403)
        |> render(Bzaar.ErrorView, "error.json", error: "User doesn't have this resource associated")
    end
  end

  def index(conn, _params) do
    stores = Repo.all(Store)
    render(conn, "index.json", stores: stores)
  end

  def list(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    stores = Repo.all(from s in Store,
      where: s.user_id == ^user.id)
    render(conn, "index.json", stores: stores)
  end

  def create(conn, %{"store" => store_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = Store.changeset(%Store{ user_id: user.id }, store_params)
    
    case Repo.insert(changeset) do
      {:ok, store} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", store_path(conn, :show, store))
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
    user = Guardian.Plug.current_resource(conn)
    unless store.user_id == user.id do
      conn
      |> put_status(403)
      |> render(Bzaar.ErrorView, "error.json", error: "User doesn't have this resource associated")
    end
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

  def upload(conn, %{"store_id" => id, "image_name" => image_name, "mimetype" => mimetype}) do
    path = "store_images/#{id}/logo/#{image_name}"
    {:ok, signed_url} = S3Uploader.generate_url(path, mimetype)
    conn
    |> put_status(:created)
    |> render("image.json", %{signed_url: signed_url, image_path: path, image_url: S3Uploader.get_access_bucket(path)})
  end

end
