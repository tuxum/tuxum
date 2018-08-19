defmodule Core.Orders.OrderInvoice do
  use Core.Schema

  alias Core.Orders.OnetimeOrderInvoice

  schema "order_invoices" do
    has_one :onetime_order_invoice, OnetimeOrderInvoice
    has_one :onetime_order, through: [:onetime_order_invoice, :onetime_order]

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(order_invoice, attrs \\ %{}) do
    order_invoice
    |> cast(attrs, [])
  end

  @impl Core.Schema
  def update_changeset(order_invoice, attrs \\ %{}) do
    insert_changeset(order_invoice, attrs)
  end
end
