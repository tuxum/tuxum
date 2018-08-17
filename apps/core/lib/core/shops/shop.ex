defmodule Core.Shops.Shop do
  use Core.Schema

  alias Core.Accounts.Owner
  alias Core.Shops.{Customer, OnetimeProduct, SubscriptionProduct}

  schema "shops" do
    field :name, :string

    belongs_to :owner, Owner

    has_many :customers, Customer
    has_many :onetime_products, OnetimeProduct
    has_many :subscription_products, SubscriptionProduct

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(owner, attrs \\ %{}) do
    owner
    |> cast(attrs, ~w[name]a)
    |> validate_required(~w[name]a)
    |> unique_constraint(:owner_id, name: :shops_owner_id_index)
  end

  @impl Core.Schema
  def update_changeset(owner, attrs \\ %{}) do
    insert_changeset(owner, attrs)
  end

  def insert(shop, attrs) do
    shop
    |> insert_changeset(attrs)
    |> DB.primary().insert()
  end

  def update(shop, attrs) do
    shop
    |> update_changeset(attrs)
    |> DB.primary().update()
  end
end
