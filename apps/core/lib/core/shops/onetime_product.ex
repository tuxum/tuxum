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
    |> validate_required(~w[name is_public price shop_id]a)
    |> validate_change(:price, &price_should_be_positive/2)
    |> assoc_constraint(:shop)
    |> set_default_shipping_fee()
  end

  def update_changeset(onetime_product, attrs \\ %{}) do
    onetime_product
    |> cast(attrs, ~w[name is_public price shipping_fee])
    |> validate_required(~w[name is_public price]a)
    |> validate_change(:price, &price_should_be_positive/2)
    |> assoc_constraint(:shop)
  end

  defp price_should_be_positive(:price, %{amount: amount}) do
    if Decimal.new(0) |> Decimal.equal?(amount) do
      [price: "must be greater then 0"]
    else
      []
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
