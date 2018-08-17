defmodule DB.Repo.Migrations.AddDeliveryPlansTable do
  use Ecto.Migration

  def change do
    create table(:delivery_plans, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :subscription_product_id, references(:subscription_products, type: :uuid), null: false
      add :interval_id, references(:intervals, type: :uuid), null: false

      timestamps()
    end
  end
end
