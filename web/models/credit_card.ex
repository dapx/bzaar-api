defmodule Bzaar.CreditCard do
  use Bzaar.Web, :model

  schema "credit_cards" do
    field :name, :string
    field :number, :float
    field :cvc, :string
    field :expire, :string
    field :active, :boolean, default: false
    belongs_to :user, Bzaar.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :number, :cvc, :expire, :active])
    |> validate_required([:name, :number, :cvc, :expire, :active])
  end
end
