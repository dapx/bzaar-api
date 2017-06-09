defmodule Bzaar.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :surname, :string
      add :email, :string
      add :active, :boolean, default: false, null: false
      add :image, :string
      add :password_hash, :string
      add :shopkeeper, :boolean, default: false, null: false

      timestamps()
    end
    create unique_index(:users, [:email])

  end
end
