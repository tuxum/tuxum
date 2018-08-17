defmodule Core.Shops.CustomerAddress do
  use Core.Schema

  alias Core.Shops.{Customer, Address}

  schema "customers_addresses" do
    belongs_to :customer, Customer
    belongs_to :address, Address

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(customer_address, attrs \\ %{}) do
    customer_address
    |> cast(attrs, [])
  end

  @impl Core.Schema
  def update_changeset(customer_address, attrs \\ %{}) do
    insert_changeset(customer_address, attrs)
  end

  def insert(customer_address, attrs) do
    customer_address
    |> insert_changeset(attrs)
    |> DB.primary().insert()
  end

  def update(customer_address, attrs) do
    customer_address
    |> update_changeset(attrs)
    |> DB.primary().update()
  end
end
