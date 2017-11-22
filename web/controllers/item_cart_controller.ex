defmodule Bzaar.ItemCartController do
  use Bzaar.Web, :controller

  alias Bzaar.{ItemCart, Product}

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    item_cart = Repo.all(from i in ItemCart,
        where: i.user_id == ^user.id,
        preload: [:product])
    render(conn, "index_product.json", item_cart: item_cart)
  end

  def create(conn, %{"item_cart" => item_cart_params}) do
    user = Guardian.Plug.current_resource(conn)
    params = %{item_cart_params | "status" => 0}
    item = build_assoc(user, :item_cart)
      |> ItemCart.changeset(params)
      |> Repo.insert
    #changeset = ItemCart.changeset(%ItemCart{ user_id: user.id }, item_cart_params)

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
    item_cart = Repo.get!(ItemCart, id)
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
