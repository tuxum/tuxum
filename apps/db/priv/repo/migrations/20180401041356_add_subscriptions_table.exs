defmodule DB.Repo.Migrations.AddSubscriptionsTable do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :shop_id, references(:shops), null: false
      add :subscription_product_id, references(:subscription_products), null: false

      timestamps()
    end
  end
end
