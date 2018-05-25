defmodule Bzaar.ItemCartController do
  use Bzaar.Web, :controller

  alias Bzaar.{ItemCart, Store, User, Product, Size}

  plug :validate_nested_resource when action in [:update]

  def validate_nested_resource(conn, _) do
    with %User{active: active} = user when active != false <- Guardian.Plug.current_resource(conn),
         %{"item_cart" => new_item} when not is_nil(new_item) <- (conn.params), # Get future state
         %{"id" => item_id, "status" => new_status} <- new_item, # Get item id and new status
         %ItemCart{status: old_status} <- Repo.get_by!(ItemCart, [id: item_id, user_id: user.id])
    do
      cond do
        (old_status == 3 and new_status == 4) or # Allow to change to received product
          (old_status < 1 and new_status < 1) -> conn # Allow to confirm purchase

        new_status > 1 -> conn # Users can't modify, store owner only
          |> show_error("Apenas o lojista pode alterar este status")

        true -> conn # else allow all
      end
    else
      %User{active: false} ->
        conn
        |> show_error("Você precisa confirmar seu e-mail")
      nil -> conn
        |> show_error("Item not found!")
      _ -> conn
        |> show_error("Ocorreu um erro!")
    end
  end

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    item_cart = Repo.all(from i in ItemCart,
        where: i.user_id == ^user.id,
        preload: [
          :address,
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
    [%{url: url}| tail] = size.product.images
    %{
      "size_name" => size.name,
      "product_name" => size.product.name,
      "size_price" => size.price,
      "product_image" => url
    }
  end

  def create(conn, %{"item_cart" => item_cart_params}) do
    user = Guardian.Plug.current_resource(conn)
    params = %{item_cart_params | "status" => 0}
    size = load_size(params)
    size_params = get_size_fields(size)
    item_cart_params = Map.merge(params, size_params)
    item = user
      |> build_assoc(:item_cart)
      |> ItemCart.cast_address_changeset(item_cart_params)
      |> Repo.insert
    case item do
      {:ok, item_cart} ->
        item_cart = Repo.preload(item_cart, :address)
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
    item_cart = ItemCart
        |> from()
        |> preload([:address, :size, {:size, [:product, {:product, [:images]}]}])
        |> Repo.get!(id)
    render(conn, "show.json", item_cart: item_cart)
  end

  def update(conn, %{"id" => id, "item_cart" => item_cart_params}) do
    item_cart = ItemCart
      |> Repo.get!(id)
      |> Repo.preload([
          :user, :address, :size, {:size, [
            :product, {:product, [
              :images, :store, {:store, [
                :user
              ]}
            ]}
          ]}
        ])
    changeset = ItemCart.cast_address_changeset(item_cart, item_cart_params)

    case Repo.update(changeset) do
      {:ok, item_cart} ->
        if item_cart.status == 1 do
          item_cart |> Bzaar.Email.notify_new_order() |> Bzaar.Mailer.deliver_later
        end
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
        |> render(Bzaar.ErrorView, "error.json", error: "You can't remove a order already processed")
    end
  end

  defp show_error(conn, error) do
    conn
    |> put_status(403)
    |> render(Bzaar.ErrorView, "error.json", error: error)
    |> halt # Used to prevend Plug.Conn.AlreadySentError
  end
end
