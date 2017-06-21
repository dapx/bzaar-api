defmodule Bzaar.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :price, :float
      add :quantity, :integer
      add :size, :string
      add :store_id, references(:stores, on_delete: :nothing)

      timestamps()
    end
    create index(:products, [:store_id])

  end
end
