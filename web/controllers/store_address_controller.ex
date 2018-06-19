defmodule Bzaar.StoreAddressController do
  use Bzaar.Web, :controller

  alias Bzaar.StoreAddress

  def index(conn, _params) do
    store_address = Repo.all(StoreAddress)
    render(conn, "index.json", store_address: store_address)
  end

  def create(conn, %{"store_address" => store_address_params, "store_id" => store_id}) do
    changeset = StoreAddress.changeset(%StoreAddress{}, store_address_params)

    case Repo.insert(changeset) do
      {:ok, store_address} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", store_store_address_path(conn, :show, store_address, store_id))
        |> render("show.json", store_address: store_address)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    store_address = Repo.get!(StoreAddress, id)
    render(conn, "show.json", store_address: store_address)
  end

  def update(conn, %{"id" => id, "store_address" => store_address_params}) do
    store_address = Repo.get!(StoreAddress, id)
    changeset = StoreAddress.changeset(store_address, store_address_params)

    case Repo.update(changeset) do
      {:ok, store_address} ->
        render(conn, "show.json", store_address: store_address)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    store_address = Repo.get!(StoreAddress, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(store_address)

    send_resp(conn, :no_content, "")
  end
end
