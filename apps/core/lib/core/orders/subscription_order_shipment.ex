defmodule Core.Orders.SubscriptionOrderShipment do
  use Core.Schema

  alias Core.Orders.{SubscriptionOrder, OrderShipment}

  schema "subscription_order_shipments" do
    belongs_to :subscription_order, SubscriptionOrder
    belongs_to :order_shipment, OrderShipment

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(subscription_order_shipment, attrs \\ %{}) do
    subscription_order_shipment
    |> cast(attrs, [])
  end

  @impl Core.Schema
  def update_changeset(subscription_order_shipment, attrs \\ %{}) do
    insert_changeset(subscription_order_shipment, attrs)
  end
end
