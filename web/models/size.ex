defmodule Bzaar.Size do
  use Bzaar.Web, :model
  
  # https://github.com/elixir-ecto/ecto/issues/840
  @derive {Poison.Encoder, only: [:id, :name, :quantity, :price]}
  schema "sizes" do
    field :name, :string
    field :quantity, :integer
    field :price, :float
    belongs_to :product, Bzaar.Product

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :quantity, :price])
    |> assoc_constraint(:product)
    |> validate_required([:name, :quantity, :price])
  end

end
