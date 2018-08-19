defmodule Core.Orders.SubscriptionOrder do
  use Core.Schema

  alias Core.Orders.{SubscriptionOrderInvoice, SubscriptionOrderShipment, Interval}
  alias Core.Shops.{SubscriptionProduct, Customer}

  schema "subscription_orders" do
    field :price, Money.Ecto.Composite.Type

    belongs_to :subscription_product, SubscriptionProduct
    belongs_to :customer, Customer
    belongs_to :delivery_interval, Interval
    belongs_to :billing_interval, Interval
    has_one :subscription_order_invoice, SubscriptionOrderInvoice
    has_one :invoice, through: [:subscription_order_invoice, :order_invoice]
    has_one :subscription_order_shipment, SubscriptionOrderShipment
    has_one :shipment, through: [:subscription_order_shipment, :order_shipment]

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(subscription_order, attrs \\ %{}) do
    subscription_order
    |> cast(attrs, ~w[price]a)
    |> validate_required(~w[price]a)
  end

  @impl Core.Schema
  def update_changeset(subscription_order, attrs \\ %{}) do
    insert_changeset(subscription_order, attrs)
  end
end
