defmodule Core.Orders.OnetimeOrderInvoice do
  use Core.Schema

  alias Core.Orders.{OnetimeOrder, OrderInvoice}

  schema "onetime_order_invoices" do
    belongs_to :onetime_order, OnetimeOrder
    belongs_to :order_invoice, OrderInvoice

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(onetime_order_invoice, attrs \\ %{}) do
    onetime_order_invoice
    |> cast(attrs, [])
  end

  @impl Core.Schema
  def update_changeset(onetime_order_invoice, attrs \\ %{}) do
    insert_changeset(onetime_order_invoice, attrs)
  end
end
