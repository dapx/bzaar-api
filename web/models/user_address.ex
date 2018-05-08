defmodule Bzaar.UserAddress do
  use Bzaar.Web, :model

  # https://github.com/elixir-ecto/ecto/issues/840
  # when preload user_address, it comes with ecto meta field
  # to solve it, We define what fields should be parse to a map.
  @derive { Poison.Encoder, only: [
      :id, :name, :uf, :city, :neighborhood, :street, :number, :complement
    ]}
  schema "user_address" do
    field :name, :string
    field :cep, :integer
    field :uf, :string
    field :city, :string
    field :neighborhood, :string
    field :street, :string
    field :number, :integer
    field :complement, :string
    belongs_to :user, Bzaar.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :cep, :uf, :city, :neighborhood, :street, :number, :complement, :user_id])
    |> validate_required([:name, :cep, :uf, :city, :neighborhood, :street, :number, :complement, :user_id])
  end
end
