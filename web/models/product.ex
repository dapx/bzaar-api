defmodule Bzaar.Product do
  use Bzaar.Web, :model

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :float
    field :quantity, :integer
    field :size, :string
    belongs_to :store, Bzaar.Store
    has_many :product_images, Bzaar.ProductImage

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :price, :quantity, :size])
    |> validate_required([:name, :description, :price, :quantity, :size])
  end
end
