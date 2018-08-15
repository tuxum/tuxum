defmodule DB.Repo.Migrations.AddSubscriptionProductsTable do
  use Ecto.Migration

  def change do
    create table(:subscription_products, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :is_public, :boolean, null: false, default: true
      add :price, :money_with_currency, null: false
      add :setup_fee, :money_with_currency, null: false
      add :shipping_fee, :money_with_currency, null: false
      add :shop_id, references(:shops, type: :uuid), null: false
      add :delivery_interval_id, references(:delivery_intervals, type: :uuid), null: false

      timestamps()
    end
  end
end
