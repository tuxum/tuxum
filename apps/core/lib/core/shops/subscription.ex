defmodule Core.Shops.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  alias Core.Shops.{Shop, SubscriptionProduct}

  schema "subscriptions" do
    belongs_to :shop, Shop
    belongs_to :subscription_product, SubscriptionProduct

    timestamps()
  end

  def insert_changeset(subscription, attrs \\ %{}) do
    subscription
    |> cast(attrs, ~w[])
    |> assoc_constraint(:shop)
    |> assoc_constraint(:subscription_product)
  end

  def update_changeset(subscription, attrs \\ %{}) do
    subscription
    |> insert_changeset(attrs)
  end

  def insert(subscription, attrs) do
    subscription
    |> insert_changeset(attrs)
    |> DB.primary().insert()
  end

  def update(subscription, attrs) do
    subscription
    |> update_changeset(attrs)
    |> DB.primary().update()
  end
end
