defmodule APIWeb.Schema.ShopQueryTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Accounts, Shops, Fixtures}

  describe "querying a shop" do
    setup %{conn: conn} do
      params = %{owner: Fixtures.owner(), shop:  Fixtures.shop()}
      {:ok, %{owner: owner, shop: shop}} = Core.signup(params)
      {:ok, _} = Shops.insert_onetime_product(shop, Fixtures.onetime_product())
      {:ok, _} = Shops.insert_subscription_product(shop, Fixtures.subscription_product())
      {:ok, token} = Accounts.token_from_owner(owner)
      conn = conn |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, owner: owner, shop: shop}
    end

    test "query big data", %{conn: conn} do
      assert graphql_data(conn, """
        query {
          owner {
            name
            shop {
              name
              onetime_products {
                id
                name
              }
              subscription_products {
                id
                name
                delivery_interval {
                  name
                  interval_days
                }
              }
            }
          }
        }
      """)
    end
  end
end
