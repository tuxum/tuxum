defmodule Core.Shops.SubscriptionProduct do
  use Core.Schema

  alias Core.Shops.{Shop, DeliveryInterval}

  schema "subscription_products" do
    field :name, :string
    field :is_public, :boolean
    field :price, Money.Ecto.Composite.Type
    field :setup_fee, Money.Ecto.Composite.Type
    field :shipping_fee, Money.Ecto.Composite.Type

    belongs_to :shop, Shop
    belongs_to :delivery_interval, DeliveryInterval

    timestamps()
  end

  def insert_changeset(subscription_product, attrs \\ %{}) do
    subscription_product
    |> cast(attrs, ~w[name is_public price setup_fee shipping_fee delivery_interval_id])
    |> validate_required(~w[name is_public price delivery_interval_id]a)
    |> assoc_constraint(:shop)
    |> assoc_constraint(:delivery_interval)
    |> set_default_shipping_fee()
    |> set_default_setup_fee()
    |> price_should_be_positive()
    |> setup_fee_should_be_positive()
    |> shipping_fee_should_be_positive()
    |> currencies_should_be_same()
  end

  def update_changeset(subscription_product, attrs \\ %{}) do
    subscription_product
    |> cast(attrs, ~w[name is_public price setup_fee shipping_fee delivery_interval_id])
    |> validate_required(~w[name is_public price delivery_interval_id]a)
    |> assoc_constraint(:shop)
    |> assoc_constraint(:delivery_interval)
    |> price_should_be_positive()
    |> setup_fee_should_be_positive()
    |> shipping_fee_should_be_positive()
    |> currencies_should_be_same()
  end

  defp price_should_be_positive(changeset) do
    should_be_positive(changeset, :price)
  end

  defp setup_fee_should_be_positive(changeset) do
    should_be_positive(changeset, :setup_fee)
  end

  defp shipping_fee_should_be_positive(changeset) do
    should_be_positive(changeset, :shipping_fee)
  end

  defp should_be_positive(changeset, column) do
    validate_change(changeset, column, fn _column, %{amount: amount} ->
      if Decimal.equal?(amount, 0) || Decimal.positive?(amount) do
        []
      else
        [{column, "must be greater then 0"}]
      end
    end)
  end

  defp currencies_should_be_same(changeset) do
    {_, price} = fetch_field(changeset, :price)
    {_, setup_fee} = fetch_field(changeset, :setup_fee)
    {_, shipping_fee} = fetch_field(changeset, :shipping_fee)

    with true <- price.currency == setup_fee.currency,
         true <- price.currency == shipping_fee.currency do
      changeset
    else
      false ->
        add_error(changeset, :price, "price and shipping_fee must have the same currency")
    end
  end

  defp set_default_setup_fee(changeset) do
    set_default_fee(changeset, :setup_fee)
  end

  defp set_default_shipping_fee(changeset) do
    set_default_fee(changeset, :shipping_fee)
  end

  defp set_default_fee(changeset, column) do
    if get_change(changeset, column) |> is_nil do
      %Money{currency: currency} = get_change(changeset, :price)
      changeset |> put_change(column, Money.new(currency, 0))
    else
      changeset
    end
  end

  def insert(subscription_product, attrs) do
    subscription_product
    |> insert_changeset(attrs)
    |> DB.primary().insert()
  end

  def update(subscription_product, attrs) do
    subscription_product
    |> update_changeset(attrs)
    |> DB.primary().update()
  end
end
