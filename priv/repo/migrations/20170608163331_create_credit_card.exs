defmodule Bzaar.Repo.Migrations.CreateCreditCard do
  use Ecto.Migration

  def change do
    create table(:credit_cards) do
      add :name, :string
      add :number, :float
      add :cvc, :string
      add :expire, :string
      add :active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:credit_cards, [:user_id])

  end
end
