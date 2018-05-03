defmodule Bzaar.Repo.Migrations.UseUtcTimestamp do
  use Ecto.Migration

  def change do
    alter table (:credit_cards) do
      modify :inserted_at, :utc_datetime
      modify :updated_at, :utc_datetime
    end
    alter table (:dispatchers) do
      modify :inserted_at, :utc_datetime
      modify :updated_at, :utc_datetime
    end
    alter table (:item_cart) do
      modify :inserted_at, :utc_datetime
      modify :updated_at, :utc_datetime
    end
    alter table (:product_images) do
      modify :inserted_at, :utc_datetime
      modify :updated_at, :utc_datetime
    end
    alter table (:products) do
      modify :inserted_at, :utc_datetime
      modify :updated_at, :utc_datetime
    end
    alter table (:sizes) do
      modify :inserted_at, :utc_datetime
      modify :updated_at, :utc_datetime
    end
    alter table (:stores) do
      modify :inserted_at, :utc_datetime
      modify :updated_at, :utc_datetime
    end
    alter table (:users) do
      modify :inserted_at, :utc_datetime
      modify :updated_at, :utc_datetime
    end
  end
end
