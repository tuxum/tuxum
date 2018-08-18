defmodule DB.Repo.Migrations.AddOnetimeOrderDeliveryAddressesTable do
  use Ecto.Migration

  def change do
    create table(:onetime_order_delivery_addresses, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :onetime_order_id, references(:onetime_orders, type: :uuid), null: false
      add :address_id, references(:addresses, type: :uuid), null: false

      timestamps()
    end
  end
end
