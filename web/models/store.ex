defmodule Bzaar.Store do
  use Bzaar.Web, :model
  alias Bzaar.S3Uploader

  schema "stores" do
    field :name, :string
    field :description, :string
    field :email, :string
    field :active, :boolean, default: false
    field :logo, :string, default: S3Uploader.get_access_bucket("store_images/default/default_store.png")
    belongs_to :user, Bzaar.User
    has_many :products, Bzaar.Product
    has_many :dispatchers, Bzaar.Dispatcher

    timestamps(type: :utc_datetime)
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
