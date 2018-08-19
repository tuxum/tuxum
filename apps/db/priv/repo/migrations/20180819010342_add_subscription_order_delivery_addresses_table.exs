defmodule DB.Repo.Migrations.AddSubscriptionOrderDeliveryAddressesTable do
  use Ecto.Migration

  def change do
    create table(:subscription_order_delivery_addresses, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :subscription_order_id, references(:subscription_orders, type: :uuid), null: false
      add :address_id, references(:addresses, type: :uuid), null: false

      timestamps()
    end
  end
end
