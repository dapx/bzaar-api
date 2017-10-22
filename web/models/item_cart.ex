defmodule Bzaar.ItemCart do
  use Bzaar.Web, :model

  schema "item_cart" do
    field :quantity, :integer
    field :status, :integer
    belongs_to :user, Bzaar.User
    belongs_to :product, Bzaar.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:quantity, :status, :user_id, :product_id])
    |> unique_constraint(:user_product, name: :user_product_index)
    |> validate_required([:quantity, :status, :user_id, :product_id])
  end
end
