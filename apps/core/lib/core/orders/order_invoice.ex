defmodule Core.Orders.OrderInvoice do
  use Core.Schema

  schema "order_invoices" do
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
