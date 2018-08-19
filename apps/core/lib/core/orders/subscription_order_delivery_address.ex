defmodule Core.Orders.SubscriptionOrderDeliveryAddress do
  use Core.Schema

  alias Core.Orders.{SubscriptionOrder, Address}

  schema "subscription_order_delivery_addresses" do
    belongs_to :subscription_order, SubscriptionOrder
    belongs_to :address, Address

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(subscription_order_delivery_address, attrs \\ %{}) do
    subscription_order_delivery_address
    |> cast(attrs, [])
  end

  @impl Core.Schema
  def update_changeset(subscription_order_delivery_address, attrs \\ %{}) do
    insert_changeset(subscription_order_delivery_address, attrs)
  end
end
