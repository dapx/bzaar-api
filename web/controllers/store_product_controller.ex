defmodule Bzaar.StoreProductController do
  use Bzaar.Web, :controller

  alias Bzaar.{ Product, Store, Size, ProductImage }
  alias Bzaar.S3Uploader
  import Ecto.Query

  plug :validate_nested_resource when action in [:create, :edit, :upload]

  def validate_nested_resource(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    store_id = conn.params["store_id"]
    store = Repo.one(from s in Store, where: s.id == ^store_id and s.user_id == ^user.id)

    case store do
      %Store{} -> conn
      _ -> conn
        |> put_status(403)
        |> render(Bzaar.ErrorView, "error.json", error: "User doesn't have this resource associated")
        |> halt # Used to prevend Plug.Conn.AlreadySentError
    end
  end

  def index(conn, _params) do
    store_id = conn.params["store_id"]
    images_query = from i in ProductImage, order_by: i.sequence
    products = Repo.all(from p in Product,
      where: p.store_id == ^store_id,
      preload: [
        :sizes,
        images: ^images_query
      ])
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    store_id = conn.params["store_id"]
    product = Map.put(product_params, "store_id", store_id)
    changeset = Product.changeset(%Product{}, product)

    case Repo.insert(changeset) do
      {:ok, product} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", store_store_product_path(conn, :show, product, store_id))
        |> render(Bzaar.StoreProductView, "show.json", product: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    images_query = from i in ProductImage, order_by: i.sequence
    product =
      from(Product)
        |> preload([
            :sizes,
            images: ^images_query
          ])
        |> Repo.get!(id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = from(Product)
        |> preload([:images, :sizes])
        |> Repo.get!(id)
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

  ## TODO IMPLEMENTAR UPLOAD DE IMAGENS
  def upload(conn, %{"store_product_id" => id, "image_name" => image_name, "mimetype" => mimetype}) do
    path = "product_images/#{id}/default/#{image_name}"
    {:ok, signed_url} = S3Uploader.generate_url(path, mimetype)
    conn
    |> put_status(:created)
    |> render("image.json", %{signed_url: signed_url, image_path: path, image_url: S3Uploader.get_access_bucket(path)})
  end

end
