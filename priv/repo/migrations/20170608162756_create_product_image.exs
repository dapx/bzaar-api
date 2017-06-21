defmodule Bzaar.Repo.Migrations.CreateProductImage do
  use Ecto.Migration

  def change do
    create table(:product_images) do
      add :url, :string
      add :sequence, :integer
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end
    create index(:product_images, [:product_id])

  end
end
