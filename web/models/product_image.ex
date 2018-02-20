defmodule Bzaar.ProductImage do
  use Bzaar.Web, :model

  @derive {Poison.Encoder, only: [:url, :sequence]}
  schema "product_images" do
    field :url, :string
    field :sequence, :integer
    belongs_to :product, Bzaar.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :sequence, :product_id])
    |> validate_required([:url, :sequence, :product_id])
  end
end
