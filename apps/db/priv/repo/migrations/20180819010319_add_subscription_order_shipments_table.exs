defmodule DB.Repo.Migrations.AddSubscriptionOrderShipmentsTable do
  use Ecto.Migration

  def change do
    create table(:subscription_order_shipments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :subscription_order_id, references(:subscription_orders, type: :uuid), null: false
      add :order_shipment_id, references(:order_shipments, type: :uuid), null: false

      timestamps()
    end
  end
end
