defmodule Bzaar.StoreAddress do
  use Bzaar.Web, :model

  schema "store_address" do
    field :name, :string
    field :cep, :integer
    field :uf, :string
    field :city, :string
    field :street, :string
    field :number, :integer
    field :complement, :string
    field :latitude, :float
    field :longitude, :float
    belongs_to :store, Bzaar.Store

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :cep, :uf, :city, :street, :number, :complement, :latitude, :longitude])
    |> validate_required([:name, :cep, :uf, :city, :street, :number, :complement, :latitude, :longitude])
  end
end
