defmodule Core.Shops.CustomerAddress do
  use Ecto.Schema
  import Ecto.Changeset

  alias Core.Shops.{Customer, Address}

  schema "customer_addresses" do
    belongs_to :customer, Customer
    belongs_to :address, Address

    timestamps()
  end

  def changeset(customer_address, attrs \\ %{}) do
    customer_address
    |> cast(attrs, [])
  end

  def insert(customer_address, attrs) do
    customer_address
    |> changeset(attrs)
    |> DB.primary().insert()
  end

  def update(customer_address, attrs) do
    customer_address
    |> changeset(attrs)
    |> DB.primary().update()
  end
end
