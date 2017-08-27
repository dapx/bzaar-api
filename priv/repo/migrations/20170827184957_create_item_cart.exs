defmodule Bzaar.Repo.Migrations.CreateItemCart do
  use Ecto.Migration

  def change do
    create table(:item_cart) do
      add :quantity, :integer
      add :status, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end
    create index(:item_cart, [:user_id])
    create index(:item_cart, [:product_id])
    create unique_index(:item_cart, [:user_id, :product_id], name: :user_product_index)

  end
end
