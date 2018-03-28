defmodule Core.Shops.OnetimeProductTest do
  use Core.DataCase, async: true

  alias Core.Shops.OnetimeProduct

  @params Core.Fixtures.onetime_product()

  describe "insert_changeset/2" do
    setup do
      %{product: %OnetimeProduct{shop_id: 1}}
    end

    test "puts default shipping_fee", %{product: product} do
      params = @params |> Map.put(:shipping_fee, nil)

      shipping_fee = product
        |> OnetimeProduct.insert_changeset(params)
        |> Ecto.Changeset.get_change(:shipping_fee)

      assert to_string(shipping_fee.currency) == params.price.currency
      assert Decimal.equal?(shipping_fee.amount, Decimal.new(0))
    end

    test "errors when currencies don't match", %{product: product} do
      params = @params
        |> Map.put(:price, Money.new(:JPY, 5000))
        |> Map.put(:shipping_fee, Money.new(:USD, 5))

      changeset = OnetimeProduct.insert_changeset(product, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:price)
    end

    test "errors when price is negative", %{product: product} do
      params = @params |> Map.put(:price, Money.new(:USD, -500))

      changeset = OnetimeProduct.insert_changeset(product, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:price)
    end

    test "errors when shipping_fee is negative", %{product: product} do
      params = @params |> Map.put(:shipping_fee, Money.new(:USD, -5))

      changeset = OnetimeProduct.insert_changeset(product, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:shipping_fee)
    end
  end
end
