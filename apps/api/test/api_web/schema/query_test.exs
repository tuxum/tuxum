defmodule APIWeb.Schema.ShopQueryTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Accounts, Shops, Fixtures}

  describe "querying a shop" do
    setup %{conn: conn} do
      params = %{owner: Fixtures.owner(), shop: Fixtures.shop()}
      {:ok, %{owner: owner, shop: shop}} = Accounts.signup(params)
      {:ok, _} = Shops.insert_customer(shop, Fixtures.customer())
      {:ok, _} = Shops.insert_onetime_product(shop, Fixtures.onetime_product())

      delivery_interval = Shops.delivery_intervals() |> List.first
      product_params = Fixtures.subscription_product(delivery_interval_id: delivery_interval.id)
      {:ok, _} = Shops.insert_subscription_product(shop, product_params)

      {:ok, token} = Accounts.token_from_owner(owner)
      conn = conn |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, owner: owner, shop: shop}
    end

    test "query big data", %{conn: conn} do
      assert graphql_data(conn, """
               query {
                 owner {
                   id
                   name
                   email
                   shop {
                     id
                     name
                     customers (first: 10) {
                       edges {
                         cursor
                         node {
                           name
                           email
                         }
                       }
                     }
                     onetime_products (first: 10) {
                       edges {
                         cursor
                         node {
                           id
                           shop_id
                           name
                           is_public
                           price {
                             amount
                             currency
                           }
                           shipping_fee {
                             amount
                             currency
                           }
                         }
                       }
                     }
                     subscription_products (first: 10) {
                       edges {
                         cursor
                         node {
                           id
                           shop_id
                           name
                           is_public
                           price {
                             amount
                             currency
                           }
                           setup_fee {
                             amount
                             currency
                           }
                           shipping_fee {
                             amount
                             currency
                           }
                           delivery_interval {
                             name
                             interval_days
                           }
                         }
                       }
                     }
                   }
                 }
               }
             """)
    end
  end
end
