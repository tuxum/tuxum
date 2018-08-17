defmodule Core.Shops.OnetimeProduct do
  use Core.Schema

  alias Core.Shops.Shop

  schema "onetime_products" do
    field :name, :string
    field :is_public, :boolean
    field :price, Money.Ecto.Composite.Type

    belongs_to :shop, Shop

    timestamps()
  end

  @impl Core.Schema
  def insert_changeset(onetime_product, attrs \\ %{}) do
    onetime_product
    |> cast(attrs, ~w[name is_public price])
    |> validate_required(~w[name is_public price]a)
    |> assoc_constraint(:shop)
    |> price_should_be_positive()
  end

  @impl Core.Schema
  def update_changeset(onetime_product, attrs \\ %{}) do
    onetime_product
    |> cast(attrs, ~w[name is_public price])
    |> validate_required(~w[name is_public price]a)
    |> assoc_constraint(:shop)
    |> price_should_be_positive()
  end

  defp price_should_be_positive(changeset) do
    should_be_positive(changeset, :price)
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
