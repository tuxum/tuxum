defmodule Core.Orders.OnetimeOrder do
  use Core.Schema

  alias Core.Shops.{OnetimeProduct, Customer, OnetimeOrderInvoice}

  schema "onetime_orders" do
    field :price, Money.Ecto.Composite.Type

    belongs_to :onetime_product, OnetimeProduct
    belongs_to :customer, Customer
    has_one :onetime_order_invoice, OnetimeOrderInvoice
    has_one :invoice, through: [:onetime_order_invoice, :order_invoice]

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(onetime_order, attrs \\ %{}) do
    onetime_order
    |> cast(attrs, ~w[price]a)
    |> validate_required(~w[price]a)
  end

  @impl Core.Schema
  def update_changeset(onetime_order, attrs \\ %{}) do
    insert_changeset(onetime_order, attrs)
  end
end
