defmodule Bzaar.Repo.Migrations.DropUniqueConstraintFromProductImages do
  use Ecto.Migration

  def change do
    drop unique_index(:product_images, [:product_id, :sequence], name: :product_images_product_id_sequence_index)
  end
end
