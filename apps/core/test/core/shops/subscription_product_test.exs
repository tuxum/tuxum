defmodule Core.Shops.SubscriptionProductTest do
  use Core.DataCase, async: true

  alias Core.Shops
  alias Core.Shops.SubscriptionProduct

  @delivery_interval Shops.delivery_intervals() |> List.first
  @params Core.Fixtures.subscription_product(delivery_interval_id: @delivery_interval.id)

  describe "insert_changeset/2" do
    setup do
      %{product: %SubscriptionProduct{shop_id: 1}}
    end

    test "puts default setup_fee", %{product: product} do
      params = @params |> Map.put(:setup_fee, nil)

      setup_fee =
        product
        |> SubscriptionProduct.insert_changeset(params)
        |> Ecto.Changeset.get_change(:setup_fee)

      assert to_string(setup_fee.currency) == params.price.currency
      assert Decimal.equal?(setup_fee.amount, Decimal.new(0))
    end

    test "errors when currencies don't match", %{product: product} do
      params = @params |> Map.put(:price, Money.new(:JPY, 5000))

      changeset = SubscriptionProduct.insert_changeset(product, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:price)
    end

    test "errors when price is negative", %{product: product} do
      params = @params |> Map.put(:price, Money.new(:USD, -500))

      changeset = SubscriptionProduct.insert_changeset(product, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:price)
    end

    test "errors when setup_fee is negative", %{product: product} do
      params = @params |> Map.put(:setup_fee, Money.new(:USD, -5))

      changeset = SubscriptionProduct.insert_changeset(product, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:setup_fee)
    end

    test "errors when delivery_interval_id is missing", %{product: product} do
      params = @params |> Map.delete(:delivery_interval_id)

      changeset = SubscriptionProduct.insert_changeset(product, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:delivery_interval_id)
    end
  end
end
