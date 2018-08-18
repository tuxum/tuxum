defmodule DB.Repo.Migrations.AddOnetimeOrderInvoicesTable do
  use Ecto.Migration

  def change do
    create table(:onetime_order_invoices, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :onetime_order_id, references(:onetime_orders, type: :uuid), null: false
      add :order_invoice_id, references(:order_invoices, type: :uuid), null: false

      timestamps()
    end
  end
end
