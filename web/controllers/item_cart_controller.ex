defmodule Bzaar.ItemCartController do
  use Bzaar.Web, :controller

  alias Bzaar.{ItemCart, Store, User, Product, Size}

  plug :validate_nested_resource when action in [:update]

  def validate_nested_resource(conn, _) do
    params = conn.params
    user = Guardian.Plug.current_resource(conn)
    new_item = conn.params["item_cart"]
    new_status = new_item["status"]
    item_cart = get_item_by_id_and_user(params["id"], user.id)
    validate_update_action(conn, item_cart, new_status)
  end

  defp validate_update_action(conn, item_cart, new_status) do
    case { item_cart, new_status } do
      { nil, _ } -> conn
        |> put_status(403)
        |> render(Bzaar.ErrorView, "error.json", error: "User doesn't have this resource associated")
        |> halt # Used to prevend Plug.Conn.AlreadySentError
      { %ItemCart{ status: status }, new_status }
        when (status + 1) == new_status or (status - 1) == 0
         -> conn
      _ -> conn
        |> put_status(403)
        |> render(Bzaar.ErrorView, "error.json", error: "It's not possible, sorry")
        |> halt # Used to prevend Plug.Conn.AlreadySentError
    end
  end

  defp get_item_by_id_and_user(item_id, user_id) do
    Repo.one(
      from i in ItemCart,
      join: z in Size,
      join: p in Product,
      join: s in Store,
     where: i.id == ^item_id
        and i.size_id == z.id
        and z.product_id == p.id
        and p.store_id == s.id
        and s.user_id == ^user_id
    )
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
        |> render(Bzaar.ErrorView, "error.json", error: "You can't remove a product in process");
    end
  end
end
