defmodule Bzaar.DeliveryAddress do
  use Bzaar.Web, :model

  @derive { Poison.Encoder, only: [
    :id, :name, :cep, :uf, :city, :neighborhood, :street, :number, :complement
  ]}
  schema "delivery_address" do
    field :name, :string
    field :cep, :integer
    field :uf, :string
    field :city, :string
    field :neighborhood, :string
    field :street, :string
    field :number, :integer
    field :complement, :string
    belongs_to :item_cart, Bzaar.ItemCart

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :cep, :uf, :city, :neighborhood, :street, :number, :complement])
    |> assoc_constraint(:item_cart)
    |> validate_required([:name, :cep, :uf, :city, :neighborhood, :street, :number, :complement])
  end
end
