defmodule Bzaar.Dispatcher do
  use Bzaar.Web, :model

  schema "dispatchers" do
    field :company, :string
    field :email, :string
    field :distance_limit, :integer
    field :time_to_deliver, :integer
    belongs_to :store, Bzaar.Store

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:company, :email, :distance_limit, :time_to_deliver])
    |> validate_required([:company, :email, :distance_limit, :time_to_deliver])
  end
end
