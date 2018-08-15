defmodule Core.Shops.OnetimeProduct do
  use Core.Schema

  alias Core.Shops.Shop

  schema "onetime_products" do
    field :name, :string
    field :is_public, :boolean
    field :price, Money.Ecto.Composite.Type
    field :shipping_fee, Money.Ecto.Composite.Type

    belongs_to :shop, Shop

    timestamps()
  end

  def insert_changeset(onetime_product, attrs \\ %{}) do
    onetime_product
    |> cast(attrs, ~w[name is_public price shipping_fee])
    |> validate_required(~w[name is_public price]a)
    |> assoc_constraint(:shop)
    |> set_default_shipping_fee()
    |> price_should_be_positive()
    |> shipping_fee_should_be_positive()
    |> currencies_should_be_same()
  end

  def update_changeset(onetime_product, attrs \\ %{}) do
    onetime_product
    |> cast(attrs, ~w[name is_public price shipping_fee])
    |> validate_required(~w[name is_public price]a)
    |> assoc_constraint(:shop)
    |> price_should_be_positive()
    |> shipping_fee_should_be_positive()
    |> currencies_should_be_same()
  end

  defp price_should_be_positive(changeset) do
    should_be_positive(changeset, :price)
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
    {_, shipping_fee} = fetch_field(changeset, :shipping_fee)

    if price.currency == shipping_fee.currency do
      changeset
    else
      add_error(changeset, :price, "price and shipping_fee must have the same currency")
    end
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

  def insert(onetime_product, attrs) do
    onetime_product
    |> insert_changeset(attrs)
    |> DB.primary().insert()
  end

  def update(onetime_product, attrs) do
    onetime_product
    |> update_changeset(attrs)
    |> DB.primary().update()
  end
end
