defmodule Core.Shops.OnetimeProduct do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> currencies_should_be_same()
  end

  def update_changeset(onetime_product, attrs \\ %{}) do
    onetime_product
    |> cast(attrs, ~w[name is_public price shipping_fee])
    |> validate_required(~w[name is_public price]a)
    |> assoc_constraint(:shop)
    |> price_should_be_positive()
    |> currencies_should_be_same()
  end

  defp price_should_be_positive(changeset) do
    validate_change(changeset, :price, fn :price, %{amount: amount} ->
      if Decimal.new(0) |> Decimal.equal?(amount) do
        [price: "must be greater then 0"]
      else
        []
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
    case get_change(changeset, :shipping_fee) do
      nil ->
        %Money{currency: currency} = get_change(changeset, :price)
        changeset |> put_change(:shipping_fee, Money.new(currency, 0))
      _ ->
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
