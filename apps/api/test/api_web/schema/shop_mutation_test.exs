defmodule APIWeb.Schema.ShopMutationTest do
  use APIWeb.ConnCase, async: true

  describe "createShop mutation" do
    setup %{conn: conn} do
      {:ok, %{user: user}} = Core.Identities.insert_user(%{
        name: "John Doe",
        email: "john@doe.com",
        password: "s3cr3tp@ssw0rd"
      })

      {:ok, token} = Core.Identities.token_from_user(user)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, user: user}
    end

    test "inserts new shop", %{conn: conn, user: user} do
      query = """
        mutation {
          createShop(name: "My Shop") {
            name
          }
        }
      """

      data = graphql_data(conn, query)

      assert %{"createShop" => %{"name" => "My Shop"}} = data
      assert Core.Shops.find_shop(%{user_id: user.id})
    end
  end

  describe "updateShop mutation" do
    setup %{conn: conn} do
      {:ok, %{user: user}} = Core.Identities.insert_user(%{
        name: "John Doe",
        email: "john@doe.com",
        password: "s3cr3tp@ssw0rd"
      })
      {:ok, _shop} = Core.Shops.insert_shop(user, %{name: "My Shop"})

      {:ok, token} = Core.Identities.token_from_user(user)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, user: user}
    end

    test "updates shop", %{conn: conn, user: user} do
      query = """
        mutation {
          updateShop(name: "New Shop") {
            name
          }
        }
      """

      data = graphql_data(conn, query)

      assert %{"updateShop" => %{"name" => "New Shop"}} = data
      assert %{name: "New Shop"} = Core.Shops.find_shop(%{user_id: user.id})
    end
  end
end
