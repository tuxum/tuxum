defmodule APIWeb.Schema.OnetimeProductMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Shops,  Fixtures}

  describe "createOnetimeProduct mutation" do
    setup %{conn: conn} do
      {:ok, user} = Fixtures.user() |> Identities.insert_user()
      {:ok, shop} = Shops.insert_shop(user, Fixtures.shop())

      {:ok, token} = Identities.token_from_user(user)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      params = Fixtures.onetime_product()

      %{conn: conn, user: user, shop: shop, params: params}
    end

    test "inserts new onetime product", %{conn: conn, shop: shop, params: params} do
      query = """
        mutation ($shopId: ID!, $input: CreateOnetimeProductInput!) {
          createOnetimeProduct(shopId: $shopId, input: $input) {
            id
            name
          }
        }
      """
      variables = %{shopId: shop.id, input: (params)}

      data = graphql_data(conn, query, variables)

      assert %{"createOnetimeProduct" => %{"id" => id, "name" => _}} = data
      assert Shops.find_onetime_product(shop, %{id: id})
    end
  end

  describe "updateOnetimeProduct mutation" do
    setup %{conn: conn} do
      {:ok, user} = Fixtures.user() |> Identities.insert_user()
      {:ok, shop} = Shops.insert_shop(user, Fixtures.shop())
      {:ok, product} = Shops.insert_onetime_product(shop, Fixtures.onetime_product())

      {:ok, token} = Identities.token_from_user(user)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, shop: shop, product: product, params: Fixtures.onetime_product()}
    end

    test "updates onetime product", %{conn: conn, shop: shop, product: product, params: params} do
      query = """
        mutation ($productId: ID!, $input: UpdateOnetimeProductInput!) {
          updateOnetimeProduct(productId: $productId, input: $input) {
            id
            name
          }
        }
      """
      variables = %{productId: product.id, input: params}

      data = graphql_data(conn, query, variables)

      %{name: name} = params
      assert %{"updateOnetimeProduct" => %{"name" => ^name}} = data
      assert {:ok, %{name: ^name}} = Shops.find_onetime_product(shop, %{id: product.id})
    end
  end
end
