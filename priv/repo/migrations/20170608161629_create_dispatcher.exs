defmodule Bzaar.Repo.Migrations.CreateDispatcher do
  use Ecto.Migration

  def change do
    create table(:dispatchers) do
      add :company, :string
      add :email, :string
      add :distance_limit, :integer
      add :time_to_deliver, :integer
      add :store_id, references(:stores, on_delete: :nothing)

      timestamps()
    end
    create index(:dispatchers, [:store_id])

  end
end
