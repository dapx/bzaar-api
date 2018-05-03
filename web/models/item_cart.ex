defmodule Bzaar.ItemCart do
  use Bzaar.Web, :model

  schema "item_cart" do
    field :quantity, :integer
    field :status, :integer
    field :size_name, :string
    field :product_image, :string
    field :product_name, :string
    field :size_price, :float
    belongs_to :user, Bzaar.User
    belongs_to :size, Bzaar.Size

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
        :quantity, :status, :user_id,
        :size_id, :size_name, :size_price,
        :product_name, :product_image
      ])
    |> unique_constraint(:user_product, name: :user_size_index)
    |> validate_required([
        :quantity, :status, :user_id,
        :size_id, :size_name, :size_price,
        :product_name, :product_image
      ])
  end
end
