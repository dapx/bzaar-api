defmodule Bzaar.Repo.Migrations.DropItemCart do
  use Ecto.Migration

  def change do
    drop table(:item_cart)
  end
end
