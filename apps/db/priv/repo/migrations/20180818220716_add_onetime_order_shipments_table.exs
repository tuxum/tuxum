defmodule DB.Repo.Migrations.AddOnetimeOrderShipmentsTable do
  use Ecto.Migration

  def change do
    create table(:onetime_order_shipments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :onetime_order_id, references(:onetime_orders, type: :uuid), null: false
      add :order_shipment_id, references(:order_shipments, type: :uuid), null: false

      timestamps()
    end
  end
end
