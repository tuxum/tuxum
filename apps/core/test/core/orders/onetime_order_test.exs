defmodule Core.Orders.OnetimeOrderTest do
  use Core.DataCase, async: true

  alias Core.Orders.OnetimeOrder

  @params Core.Fixtures.onetime_order()

  describe "insert_changeset/2" do
    setup do
      %{onetime_order: %OnetimeOrder{onetime_product_id: "1", customer_id: "2"}}
    end

    test "returns valid product with valid params", %{onetime_order: onetime_order} do
      changeset = onetime_order |> OnetimeOrder.insert_changeset(@params)

      assert changeset.valid?
    end

    test "errors when price is blank", %{onetime_order: onetime_order} do
      params = @params |> Map.put(:price, " ")

      changeset = OnetimeOrder.insert_changeset(onetime_order, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:price)
    end
  end
end
