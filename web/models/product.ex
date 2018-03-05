defmodule Bzaar.Product do
  use Bzaar.Web, :model

  schema "products" do
    field :name, :string
    field :description, :string
    field :image, :string
    belongs_to :store, Bzaar.Store
    has_many :images, Bzaar.ProductImage, on_delete: :delete_all
    has_many :sizes, Bzaar.Size, on_delete: :delete_all

    timestamps()
  end

  defp inspect_map(map) do
    IO.puts "INSPECT"
    IO.inspect map
    IO.puts ";"
    map
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
