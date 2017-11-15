defmodule Bzaar.Repo.Migrations.AddFacebookIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :facebook_id, :string
    end
  end
end
