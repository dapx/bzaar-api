defmodule BzaarWeb.ProductImageController do
  use Bzaar.Web, :controller

  alias Bzaar.ProductImage
  alias Bzaar.S3Uploader

  def index(conn, _params) do
    product_images = Repo.all(ProductImage)
    render(conn, "index.json", product_images: product_images)
  end

  def create(conn, %{"store_product_id" => product_id, "product_image" => product_image_params}) do
    product_image = Map.put(product_image_params, "product_id", product_id)
    changeset = ProductImage.changeset_validate_product_id(%ProductImage{}, product_image)

    case Repo.insert(changeset) do
      {:ok, product_image} ->
        conn
        |> put_status(:created)
        #|> put_resp_header("location", product_image_path(conn, :show, product_image))
        |> render("show.json", product_image: product_image)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BzaarWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product_image = Repo.get!(ProductImage, id)
    render(conn, "show.json", product_image: product_image)
  end

  def update(conn, %{"id" => id, "product_image" => product_image_params}) do
    product_image = Repo.get!(ProductImage, id)
    changeset = ProductImage.changeset(product_image, product_image_params)

    case Repo.update(changeset) do
      {:ok, product_image} ->
        render(conn, "show.json", product_image: product_image)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BzaarWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_image = Repo.get!(ProductImage, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product_image)

    send_resp(conn, :no_content, "")
  end

    ## TODO IMPLEMENTAR UPLOAD DE IMAGENS
  def upload(conn, %{"store_product_id" => id, "image_name" => image_name, "mimetype" => mimetype}) do
    path = "product_images/#{id}/images/#{image_name}"
    {:ok, signed_url} = S3Uploader.generate_url(path, mimetype)
    conn
    |> put_status(:created)
    |> render("image.json", %{signed_url: signed_url, image_path: path, image_url: S3Uploader.get_access_bucket(path)})
  end
end
