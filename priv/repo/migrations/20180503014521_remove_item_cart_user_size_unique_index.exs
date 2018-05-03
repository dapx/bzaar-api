defmodule Bzaar.Repo.Migrations.RemoveItemCartUserSizeUniqueIndex do
  use Ecto.Migration

  def change do
    drop unique_index(:item_cart, [:user_id, :size_id], name: :user_size_index)
  end
end
