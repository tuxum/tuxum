defmodule Core.Orders.BillingPlan do
  use Core.Schema

  alias Core.Orders.Interval
  alias Core.Shops.SubscriptionProduct

  schema "delivery_plans" do
    field :price, Money.Ecto.Composite.Type

    belongs_to :interval, Interval
    belongs_to :subscription_product, SubscriptionProduct

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(delivery_plan, attrs \\ %{}) do
    delivery_plan
    |> cast(attrs, ~w[price]a)
  end

  @impl Core.Schema
  def update_changeset(delivery_plan, attrs \\ %{}) do
    insert_changeset(delivery_plan, attrs)
  end
end
