defmodule Bzaar.Repo.Migrations.CreateUserAddress do
  use Ecto.Migration

  def change do
    create table(:user_address) do
      add :name, :string
      add :cep, :integer
      add :uf, :string
      add :city, :string
      add :neighborhood, :string
      add :street, :string
      add :number, :integer
      add :complement, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:user_address, [:user_id])

  end
end
