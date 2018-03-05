defmodule Core.Shops.OnetimeProduct do
  use Ecto.Schema
  import Ecto.Changeset

  alias Core.Shops.Shop

  schema "onetime_products" do
    field :name, :string
    field :is_public, :boolean
    field :price, Money.Ecto.Composite.Type
    field :shipping_fee, Money.Ecto.Composite.Type, default: Money.new(:USD, 0)

    belongs_to :shop, Shop

    timestamps()
  end

  def changeset(onetime_product, attrs \\ %{}) do
    onetime_product
    |> cast(attrs, ~w[name is_public price shipping_fee])
    |> validate_required(~w[name is_public price shop_id]a)
    |> validate_change(:price, fn :price, %{amount: amount} ->
      case zero?(amount) do
        true -> [price: "must be greater then 0"]
        false -> []
      end
    end)
    |> assoc_constraint(:shop)
  end

  defp zero?(decimal) do
    Decimal.new(0) |> Decimal.equal?(decimal)
  end
end
