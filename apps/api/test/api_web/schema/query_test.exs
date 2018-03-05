defmodule APIWeb.Schema.ShopQueryTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Accounts, Fixtures}

  describe "querying a shop" do
    setup %{conn: conn} do
      params = %{owner: Fixtures.owner(), shop:  Fixtures.shop()}
      {:ok, %{owner: owner, shop: shop}} = Core.signup(params)
      {:ok, token} = Accounts.token_from_owner(owner)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      %{conn: conn, owner: owner, shop: shop}
    end

    test "query big data", %{conn: conn} do
      data = graphql_data(conn, """
        query {
          owner {
            name
            shop {
              name
              onetime_products {
                id
                name
              }
            }
          }
        }
      """)

      assert data
    end
  end
end
