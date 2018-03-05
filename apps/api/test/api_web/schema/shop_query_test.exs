defmodule APIWeb.Schema.ShopQueryTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Shops,  Fixtures}

  describe "querying a shop" do
    setup %{conn: conn} do
      {:ok, owner} = Fixtures.owner() |> Identities.insert_owner()
      {:ok, shop} = Shops.insert_shop(owner, Fixtures.shop())

      {:ok, token} = Identities.token_from_owner(owner)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, owner: owner, shop: shop}
    end

    test "get shop of the owner", %{conn: conn, shop: %{name: name}} do
      data = graphql_data(conn, """
        query {
          owner {
            shop {
              name
              onetime_products {
                id
              }
            }
          }
        }
      """)

      assert %{"owner" => %{"shop" => %{"name" => ^name}}} = data
    end
  end
end
