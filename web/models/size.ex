defmodule Bzaar.Size do
  use Bzaar.Web, :model
  
  # https://github.com/elixir-ecto/ecto/issues/840
  @derive {Poison.Encoder, only: [:name, :quantity, :price]}
  schema "sizes" do
    field :name, :string
    field :quantity, :integer
    field :price, :float
    belongs_to :product, Bzaar.Product

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
    |> cast(params, [:name, :quantity, :price])
    |> assoc_constraint(:product)
    |> validate_required([:name, :quantity, :price])
  end

end