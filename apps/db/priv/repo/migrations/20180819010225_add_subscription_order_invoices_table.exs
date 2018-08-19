defmodule DB.Repo.Migrations.AddSubscriptionOrderInvoicesTable do
  use Ecto.Migration

  def change do
    create table(:subscription_order_invoices, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :subscription_order_id, references(:subscription_orders, type: :uuid), null: false
      add :order_invoice_id, references(:order_invoices, type: :uuid), null: false

      timestamps()
    end
  end
end
