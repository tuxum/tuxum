defmodule APIWeb.Schema.ShopQueryTest do
  use APIWeb.ConnCase, async: true

  describe "querying a shop" do
    setup %{conn: conn} do
      {:ok, %{user: user}} = Core.Identities.insert_user(%{
        name: "John Doe",
        email: "john@doe.com",
        password: "s3cr3tp@ssw0rd"
      })
      {:ok, shop} = Core.Shops.insert_shop(user, %{name: "My Shop"})

      {:ok, token} = Core.Identities.token_from_user(user)
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
            }
          }
        }
      """)

      assert %{"user" => %{"shop" => %{"name" => ^name}}} = data
    end
  end
end
