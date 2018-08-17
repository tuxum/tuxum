defmodule Core.Shops.OnetimeProductTest do
  use Core.DataCase, async: true

  alias Core.Shops.OnetimeProduct

  @params Core.Fixtures.onetime_product()

  describe "insert_changeset/2" do
    setup do
      %{product: %OnetimeProduct{shop_id: 1}}
    end

    test "errors when price is negative", %{product: product} do
      params = @params |> Map.put(:price, Money.new(:USD, -500))

      changeset = OnetimeProduct.insert_changeset(product, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:price)
    end
  end
end
