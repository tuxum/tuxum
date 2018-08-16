defmodule Core.Orders.DeliveryPlan do
  use Core.Schema

  alias Core.Orders.Interval
  alias Core.Shops.SubscriptionProduct

  schema "delivery_plans" do
    belongs_to :interval, Interval
    belongs_to :subscription_product, SubscriptionProduct

    timestamps()
  end

  def insert_changeset(delivery_plan, attrs \\ %{}) do
    delivery_plan
    |> cast(attrs, [])
  end

  def update_changeset(delivery_plan, attrs \\ %{}) do
    insert_changeset(delivery_plan, attrs)
  end
end
