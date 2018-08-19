defmodule DB.Repo.Migrations.AddSubscriptionOrdersTable do
  use Ecto.Migration

  def change do
    create table(:subscription_orders, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :price, :money_with_currency, null: false
      add :customer_id, references(:customers, type: :uuid), null: false
      add :subscription_product_id, references(:subscription_products, type: :uuid), null: false
      add :delivery_interval_id, references(:intervals, type: :uuid), null: false
      add :billing_interval_id, references(:intervals, type: :uuid), null: false

      timestamps()
    end
  end
end
