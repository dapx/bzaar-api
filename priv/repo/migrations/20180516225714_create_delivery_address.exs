defmodule Bzaar.Repo.Migrations.CreateDeliveryAddress do
  use Ecto.Migration

  def change do
    create table(:delivery_address) do
      add :name, :string
      add :cep, :integer
      add :uf, :string
      add :city, :string
      add :neighborhood, :string
      add :street, :string
      add :number, :integer
      add :complement, :string
      add :item_cart_id, references(:item_cart, on_delete: :nothing)

      timestamps()
    end
    create index(:delivery_address, [:item_cart_id])

  end
end
