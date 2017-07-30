defmodule Bzaar.StoreProductController do
  use Bzaar.Web, :controller

  alias Bzaar.Product
  alias Bzaar.Store
  import Ecto.Query

  plug :validate_nested_resource when action in [:create, :edit]

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
    store_id = conn.params["store_id"]
    products = Repo.all(from p in Product, where: p.store_id == ^store_id)
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    product = Map.put(product_params, "store_id", conn.params["store_id"])
    changeset = Product.changeset(%Product{}, product)

    case Repo.insert(changeset) do
      {:ok, product} ->
        conn
        |> put_status(:created)
        #|> put_resp_header("location", store_product_path(conn, :show, product))
        |> render(Bzaar.StoreProductView, "show.json", product: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        render(conn, "show.json", product: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product)

    send_resp(conn, :no_content, "")
  end
end
