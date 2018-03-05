defmodule APIWeb.Schema.ShopMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Shops,  Fixtures}

  describe "createShop mutation" do
    setup %{conn: conn} do
      {:ok, owner} = Fixtures.owner() |> Identities.insert_owner()

      {:ok, token} = Identities.token_from_owner(owner)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, owner: owner, params: Fixtures.shop()}
    end

    test "inserts new shop", %{conn: conn, owner: owner, params: params} do
      query = """
        mutation ($input: CreateShopInput!) {
          createShop(input: $input) {
            shop {
              name
            }
          }
        }
      """
      variables = %{input: params}

      data = graphql_data(conn, query, variables)

      assert %{"createShop" => %{"shop" => %{"name" => _}}} = data
      assert {:ok, _shop} = Shops.find_shop(owner)
    end
  end

  describe "updateShop mutation" do
    setup %{conn: conn} do
      {:ok, owner} = Fixtures.owner() |> Identities.insert_owner()
      {:ok, _shop} = Shops.insert_shop(owner, Fixtures.shop())

      {:ok, token} = Identities.token_from_owner(owner)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, owner: owner, params: Fixtures.shop()}
    end

    test "updates shop", %{conn: conn, owner: owner, params: params} do
      query = """
        mutation ($input: UpdateShopInput!) {
          updateShop(input: $input) {
            shop {
              name
            }
          }
        }
      """
      variables = %{input: params}

      data = graphql_data(conn, query, variables)

      %{name: name} = params
      assert %{"updateShop" => %{"shop" => %{"name" => ^name}}} = data
      assert {:ok, %{name: ^name}} = Shops.find_shop(owner)
    end
  end
end
