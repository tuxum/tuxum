defmodule APIWeb.Schema.ShopQueryTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Shops,  Fixtures}

  describe "querying a shop" do
    setup %{conn: conn} do
      {:ok, user} = Fixtures.user() |> Identities.insert_user()
      {:ok, shop} = Shops.insert_shop(user, Fixtures.shop())

      {:ok, token} = Identities.token_from_user(user)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, user: user, shop: shop}
    end

    test "get shop of the user", %{conn: conn, shop: %{name: name}} do
      data = graphql_data(conn, """
        query {
          user {
            shop {
              name
              onetime_products {
                id
              }
            }
          }
        }
      """)

      assert %{"user" => %{"shop" => %{"name" => ^name}}} = data
    end
  end
end
