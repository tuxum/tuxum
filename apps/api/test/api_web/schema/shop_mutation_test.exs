defmodule APIWeb.Schema.ShopMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Shops,  Fixtures}

  describe "createShop mutation" do
    setup %{conn: conn} do
      {:ok, %{user: user}} = Fixtures.user()
        |> Identities.insert_user()

      {:ok, token} = Identities.token_from_user(user)
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
      assert Shops.find_shop(%{user_id: user.id})
    end
  end

  describe "updateShop mutation" do
    setup %{conn: conn} do
      {:ok, %{user: user}} = Fixtures.user() |> Identities.insert_user()
      {:ok, _shop} = Shops.insert_shop(user, Fixtures.shop())

      {:ok, token} = Identities.token_from_user(user)
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
      assert %{name: "New Shop"} = Shops.find_shop(%{user_id: user.id})
    end
  end
end
