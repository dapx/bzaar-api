defmodule Bzaar.ProductImageController do
  use Bzaar.Web, :controller

  alias Bzaar.ProductImage

  def index(conn, _params) do
    product_images = Repo.all(ProductImage)
    render(conn, "index.json", product_images: product_images)
  end

  def create(conn, %{"product_image" => product_image_params}) do
    changeset = ProductImage.changeset(%ProductImage{}, product_image_params)

    case Repo.insert(changeset) do
      {:ok, product_image} ->
        conn
        |> put_status(:created)
        #|> put_resp_header("location", product_image_path(conn, :show, product_image))
        |> render("show.json", product_image: product_image)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
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
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_image = Repo.get!(ProductImage, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product_image)

    send_resp(conn, :no_content, "")
  end
end
