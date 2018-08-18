defmodule Core.Orders.OnetimeOrderShipment do
  use Core.Schema

  alias Core.Orders.{OnetimeOrder, OrderShipment}

  schema "onetime_order_shipments" do
    belongs_to :onetime_order, OnetimeOrder
    belongs_to :order_shipment, OrderShipment

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(onetime_order_shipment, attrs \\ %{}) do
    onetime_order_shipment
    |> cast(attrs, [])
  end

  @impl Core.Schema
  def update_changeset(onetime_order_shipment, attrs \\ %{}) do
    insert_changeset(onetime_order_shipment, attrs)
  end
end
