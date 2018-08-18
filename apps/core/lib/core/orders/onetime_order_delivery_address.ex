defmodule Core.Orders.OnetimeOrderDeliveryAddress do
  use Core.Schema

  alias Core.Orders.{OnetimeOrder, Address}

  schema "onetime_order_delivery_addresses" do
    belongs_to :onetime_order, OnetimeOrder
    belongs_to :address, Address

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(onetime_order_delivery_address, attrs \\ %{}) do
    onetime_order_delivery_address
    |> cast(attrs, [])
  end

  @impl Core.Schema
  def update_changeset(onetime_order_delivery_address, attrs \\ %{}) do
    insert_changeset(onetime_order_delivery_address, attrs)
  end
end
