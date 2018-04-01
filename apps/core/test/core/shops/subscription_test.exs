defmodule Core.Shops.SubscriptionTest do
  use Core.DataCase, async: true

  alias Core.Shops.Subscription

  @params Core.Fixtures.subscription_product()

  describe "insert_changeset/2" do
    setup do
      %{subscription: %Subscription{shop_id: 1, subscription_product_id: 2}}
    end

    test "returns valid changeset", %{subscription: subscription} do
      changeset = Subscription.insert_changeset(subscription, @params)

      assert changeset.valid?
    end
  end
end
