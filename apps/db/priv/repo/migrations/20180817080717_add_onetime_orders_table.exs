defmodule DB.Repo.Migrations.AddOnetimeOrdersTable do
  use Ecto.Migration

  def change do
    create table(:onetime_orders, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :price, :money_with_currency, null: false
      add :customer_id, references(:customers, type: :uuid), null: false
      add :onetime_product_id, references(:onetime_products, type: :uuid), null: false

      timestamps()
    end
  end
end
