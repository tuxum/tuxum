defmodule DB.Repo.Migrations.AddBillingPlansTable do
  use Ecto.Migration

  def change do
    create table(:billing_plans, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :price, :money_with_currency, null: false
      add :subscription_product_id, references(:subscription_products, type: :uuid), null: false
      add :interval_id, references(:intervals, type: :uuid), null: false

      timestamps()
    end
  end
end
