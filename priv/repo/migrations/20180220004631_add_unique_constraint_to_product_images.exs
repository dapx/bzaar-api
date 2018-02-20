defmodule Bzaar.Repo.Migrations.AddUniqueConstraintToProductImage do
  use Ecto.Migration

  def change do
    create unique_index(:product_images, [:product_id, :sequence], name: :product_images_product_id_sequence_index)
  end
  
end
