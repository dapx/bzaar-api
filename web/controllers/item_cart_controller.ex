defmodule Bzaar.ItemCartController do
  use Bzaar.Web, :controller

  alias Bzaar.{ItemCart, Store, User, Product, Size}

  plug :validate_nested_resource when action in [:update]

  def validate_nested_resource(conn, _) do
    params = conn.params
    user = Guardian.Plug.current_resource(conn)
    new_item = conn.params["item_cart"]
    item_id = new_item["id"]
    old_item = Repo.one(from i in ItemCart,
      where: i.id == ^item_id and i.user_id == ^user.id
    )
    old_status = case old_item do
      nil -> conn
        |> put_status(403)
        |> render(Bzaar.ErrorView, "error.json", error: "Item not found!")
        |> halt # Used to prevend Plug.Conn.AlreadySentError
      %{status: old_status} -> old_status
    end

    new_status = new_item["status"]
    cond do # To update to status > 1, use StoreItemCartController
      old_status == 3 and new_status == 4 -> conn # Confirm delivery
      new_status > 1 -> conn
        |> put_status(403)
        |> render(Bzaar.ErrorView, "error.json", error: "It's not possible, sorry")
        |> halt # Used to prevend Plug.Conn.AlreadySentError
      old_status < 1 and new_status < 1 -> conn
      true -> conn
    end
  end

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    item_cart = Repo.all(from i in ItemCart,
        where: i.user_id == ^user.id,
        preload: [
          :size, {:size, [:product, {:product, [:images]}]}
        ])
    render(conn, "index_product.json", item_cart: item_cart)
  end

  @doc """
  Preload Product and Size based on `size_id`. 
  """
  defp load_size(%{"size_id" => size_id}) do
    Repo.one(
      from s in Size,
      where: s.id == ^size_id,
      preload: [:product, {:product, [:images]}]
    )
  end

  defp get_size_fields(size) do
    [%{ url: url }| tail] = size.product.images
    %{
      "size_name" => size.name,
      "product_name" => size.product.name,
      "size_price" => size.price,
      "product_image" => url
    }
  end

  def create(conn, %{"item_cart" => item_cart_params}) do
    user = Guardian.Plug.current_resource(conn)
    params = %{item_cart_params | "status" => 0 }
    size = load_size(params)
    size_params = get_size_fields(size)
    item_cart_params = Map.merge(params, size_params)
    item = build_assoc(user, :item_cart)
      |> ItemCart.changeset(item_cart_params)
      |> Repo.insert

    case item do
      {:ok, item_cart} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_cart_path(conn, :show, item_cart))
        |> render("show.json", item_cart: item_cart)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item_cart =
      from(ItemCart)
        |> preload([:size, {:size, [:product, {:product, [:images]}]}])
        |> Repo.get!(id)
    render(conn, "show.json", item_cart: item_cart)
  end

  def update(conn, %{"id" => id, "item_cart" => item_cart_params}) do
    item_cart = Repo.get!(ItemCart, id)
    changeset = ItemCart.changeset(item_cart, item_cart_params)

    case Repo.update(changeset) do
      {:ok, item_cart} ->
        render(conn, "show.json", item_cart: item_cart)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item_cart = Repo.get!(ItemCart, id)

    case item_cart.status do
      0 ->
        Repo.delete!(item_cart)
        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        index(conn, %{})
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ErrorView, "error.json", error: "You can't remove a order already processed");
    end
  end
end
