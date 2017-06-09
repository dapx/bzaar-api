defmodule Bzaar.Store do
  use Bzaar.Web, :model

  schema "stores" do
    field :name, :string
    field :description, :string
    field :email, :string
    field :active, :boolean, default: false
    field :logo, :string, default: "http://icons.iconarchive.com/icons/iconsmind/outline/512/Clothing-Store-icon.png"
    belongs_to :user, Bzaar.User
    has_many :products, Bzaar.Product
    has_many :dispatchers, Bzaar.Dispatcher

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :email, :active, :logo])
    |> assoc_constraint(:user)
    |> validate_required([:name, :description, :email, :active, :logo])
  end
end
