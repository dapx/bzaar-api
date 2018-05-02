defmodule Bzaar.StoreItemCartController do
  use Bzaar.Web, :controller

  alias Bzaar.{ItemCart, Store, User, Product, Size}

  plug :validate_nested_resource when action in [:update]

  def validate_nested_resource(conn, teste) do
    IO.inspect teste
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
      join: z in Size, on: z.id == i.size_id,
      join: p in Product, on: p.id == z.product_id,
      join: s in Store, on: s.id == p.store_id,
      join: u in User, on: u.id == s.user_id,
     where: i.id == ^item_id and u.id == ^user_id
    )
  end

  def index(conn, %{"store_id" => store_id}) do
    user = Guardian.Plug.current_resource(conn)
    item_cart = Repo.all(from i in ItemCart,
      join: z in Size, on: z.id == i.size_id,
      join: p in Product, on: p.id == z.product_id,
      join: s in Store, on: s.id == p.store_id,
      preload: [
        :user,
        :size, {:size, [:product, {:product, [:images]}]}
      ],
      where: p.store_id == ^store_id
    )
    render(conn, "index_product.json", store_item_cart: item_cart)
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

  def show(conn, %{"id" => id}) do
    item_cart =
      from(ItemCart)
        |> preload([:size, {:size, [:product, {:product, [:images]}]}])
        |> Repo.get!(id)
    render(conn, Bzaar.StoreItemCartView, "show.json", store_item_cart: item_cart)
  end

  def update(conn, %{"id" => id, "item_cart" => item_cart_params}) do
    item_cart = Repo.one!(from i in ItemCart,
      preload: [
        :user,
        :size, {:size, [:product, {:product, [:images]}]}
      ],
      where: i.id == ^id
    )
    changeset = ItemCart.changeset(item_cart, item_cart_params)

    case Repo.update(changeset) do
      {:ok, item_cart} ->
        render(conn, "show.json", store_item_cart: item_cart)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
