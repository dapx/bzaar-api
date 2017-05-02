defmodule Bzaar.Repo.Migrations.CreateStore do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add :name, :string
      add :description, :string
      add :email, :string
      add :active, :boolean, default: false, null: false
      add :logo, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:stores, [:user_id])

  end
end
