defmodule Bzaar.Repo.Migrations.CreateSize do
  use Ecto.Migration

  def change do
    create table(:sizes) do
      add :name, :string
      add :quantity, :integer
      add :price, :float
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end
    create index(:sizes, [:product_id])

  end
end
