defmodule DB.Repo.Migrations.AddSubscriptionProductsTable do
  use Ecto.Migration

  def change do
    create table(:subscription_products) do
      add :name, :string, null: false
      add :is_public, :boolean, null: false, default: true
      add :price, :money_with_currency, null: false
      add :setup_fee, :money_with_currency, null: false
      add :shipping_fee, :money_with_currency, null: false
      add :shop_id, references(:shops), null: false
      add :delivery_interval_id, references(:delivery_intervals), null: false

      timestamps()
    end
  end
end
