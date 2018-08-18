defmodule DB.Repo.Migrations.AddOrderInvoicesTable do
  use Ecto.Migration

  def change do
    create table(:order_invoices, primary_key: false) do
      add :id, :uuid, primary_key: true

      timestamps()
    end
  end
end
