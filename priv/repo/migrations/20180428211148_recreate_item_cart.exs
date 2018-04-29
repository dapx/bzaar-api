defmodule Bzaar.Repo.Migrations.RecreateItemCart do
  use Ecto.Migration

  def change do
    create table(:item_cart) do
      add :quantity, :integer
      add :status, :integer
      add :size_name, :string
      add :product_image, :string
      add :product_name, :string
      add :size_price, :float

      add :user_id, references(:users, on_delete: :nothing)
      add :size_id, references(:sizes, on_delete: :nothing)

      timestamps()
    end
    create index(:item_cart, [:user_id])
    create index(:item_cart, [:size_id])
    create unique_index(:item_cart, [:user_id, :size_id], name: :user_size_index)

  end
end
