defmodule Core.Orders.OrderShipment do
  use Core.Schema

  schema "order_shipments" do
    has_one :onetime_order_shipment, OnetimeOrderShipment
    has_one :onetime_order, through: [:onetime_order_shipment, :onetime_order]

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(order_shipment, attrs \\ %{}) do
    order_shipment
    |> cast(attrs, [])
  end

  @impl Core.Schema
  def update_changeset(order_shipment, attrs \\ %{}) do
    insert_changeset(order_shipment, attrs)
  end
end
