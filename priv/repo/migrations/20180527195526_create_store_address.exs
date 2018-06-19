defmodule Bzaar.Repo.Migrations.CreateStoreAddress do
  use Ecto.Migration

  def change do
    create table(:store_address) do
      add :name, :string
      add :cep, :integer
      add :uf, :string
      add :city, :string
      add :street, :string
      add :number, :integer
      add :complement, :string
      add :latitude, :float
      add :longitude, :float
      add :store_id, references(:stores, on_delete: :nothing)

      timestamps()
    end
    create index(:store_address, [:store_id])

  end
end
