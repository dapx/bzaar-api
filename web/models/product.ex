defmodule Bzaar.Product do
  use Bzaar.Web, :model

  schema "products" do
    field :name, :string
    field :description, :string
    belongs_to :store, Bzaar.Store
    has_many :images, Bzaar.ProductImage, on_delete: :delete_all, on_replace: :delete
    has_many :sizes, Bzaar.Size, on_delete: :delete_all, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :store_id])
    |> cast_assoc(:sizes, required: false)
    |> cast_assoc(:images, required: false)
    |> validate_required([:name, :description, :store_id])
  end
end
