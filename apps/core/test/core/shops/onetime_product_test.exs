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
  end
end
