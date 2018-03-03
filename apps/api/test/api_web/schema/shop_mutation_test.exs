defmodule APIWeb.Schema.ShopMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Shops,  Fixtures}

  describe "createShop mutation" do
    setup %{conn: conn} do
      {:ok, user} = Fixtures.user() |> Identities.insert_user()

      {:ok, token} = Identities.token_from_user(user)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, user: user, params: Fixtures.shop()}
    end

    test "inserts new shop", %{conn: conn, user: user, params: params} do
      query = """
        mutation ($input: CreateShopInput!) {
          createShop(input: $input) {
            name
          }
        }
      """
      variables = %{input: params}

      data = graphql_data(conn, query, variables)

      assert %{"createShop" => %{"name" => _}} = data
      assert Shops.find_shop(user)
    end
  end

  describe "updateShop mutation" do
    setup %{conn: conn} do
      {:ok, user} = Fixtures.user() |> Identities.insert_user()
      {:ok, _shop} = Shops.insert_shop(user, Fixtures.shop())

      {:ok, token} = Identities.token_from_user(user)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, user: user, params: Fixtures.shop()}
    end

    test "updates shop", %{conn: conn, user: user, params: params} do
      query = """
        mutation ($input: UpdateShopInput!) {
          updateShop(input: $input) {
            name
          }
        }
      """
      variables = %{input: params}

      data = graphql_data(conn, query, variables)

      %{name: name} = params
      assert %{"updateShop" => %{"name" => ^name}} = data
      assert %{name: ^name} = Shops.find_shop(user)
    end
  end
end
