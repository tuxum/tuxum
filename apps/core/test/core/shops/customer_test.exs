defmodule Core.Shops.CustomerTest do
  use Core.DataCase, async: true

  alias Core.Shops.Customer

  @params Core.Fixtures.customer()

  describe "insert_changeset/2" do
    setup do
      %{customer: %Customer{shop_id: 1}}
    end

    test "returns valid customer with @params", %{customer: customer} do
      changeset = customer |> Customer.insert_changeset(@params)

      assert changeset.valid?
    end

    test "errors when name is blank", %{customer: customer} do
      params = @params |> Map.put(:name, " ")

      changeset = Customer.insert_changeset(customer, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:name)
    end

    test "errors when email is blank", %{customer: customer} do
      params = @params |> Map.put(:email, " ")

      changeset = Customer.insert_changeset(customer, params)

      assert changeset.valid? == false
      assert changeset.errors |> Keyword.has_key?(:email)
    end
  end
end
