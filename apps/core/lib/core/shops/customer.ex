defmodule Core.Shops.Customer do
  use Core.Schema

  alias Core.Shops.{Shop, CustomerAddress}

  schema "customers" do
    field :name, :string
    field :email, :string

    belongs_to :shop, Shop
    has_many :customer_addresses, CustomerAddress
    has_many :addresses, through: [:customer_addresses, :address]

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(customer, attrs \\ %{}) do
    customer
    |> cast(attrs, ~w[name email]a)
    |> validate_required(~w[name email]a)
    |> assoc_constraint(:shop)
    |> unique_constraint(:email, name: :customers_shop_id_email_index)
  end

  @impl Core.Schema
  def update_changeset(customer, attrs \\ %{}) do
    insert_changeset(customer, attrs)
  end

  def insert(customer, attrs) do
    customer
    |> insert_changeset(attrs)
    |> DB.primary().insert()
  end

  def update(customer, attrs) do
    customer
    |> update_changeset(attrs)
    |> DB.primary().update()
  end
end
