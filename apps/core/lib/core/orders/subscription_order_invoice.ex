defmodule Core.Orders.SubscriptionOrderInvoice do
  use Core.Schema

  alias Core.Orders.{SubscriptionOrder, OrderInvoice}

  schema "subscription_order_invoices" do
    belongs_to :subscription_order, SubscriptionOrder
    belongs_to :order_invoice, OrderInvoice

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(subscription_order_invoice, attrs \\ %{}) do
    subscription_order_invoice
    |> cast(attrs, [])
  end

  @impl Core.Schema
  def update_changeset(subscription_order_invoice, attrs \\ %{}) do
    insert_changeset(subscription_order_invoice, attrs)
  end
end
