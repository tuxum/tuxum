defmodule DB.Repo.Migrations.AddOrderShipmentsTable do
  use Ecto.Migration

  def change do
    create table(:order_shipments, primary_key: false) do
      add :id, :uuid, primary_key: true

      timestamps()
    end
  end
end
