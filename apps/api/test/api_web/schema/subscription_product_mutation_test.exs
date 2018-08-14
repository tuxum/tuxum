defmodule APIWeb.Schema.SubscriptionProductMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Accounts, Shops, Fixtures}

  describe "createSubscriptionProduct mutation" do
    setup %{conn: conn} do
      {:ok, owner} = Fixtures.owner() |> Accounts.insert_owner()
      {:ok, shop} = Shops.insert_shop(owner, Fixtures.shop())
      {:ok, token} = Accounts.token_from_owner(owner)
      conn = conn |> put_req_header("authorization", "Bearer #{token}")

      params = Fixtures.subscription_product()

      %{conn: conn, owner: owner, shop: shop, params: params}
    end

    test "inserts new subscription product", %{conn: conn, shop: shop, params: params} do
      query = """
        mutation ($input: CreateSubscriptionProductInput!) {
          createSubscriptionProduct(input: $input) {
            subscriptionProduct {
              id
              name
            }
          }
        }
      """

      variables = %{input: params}

      data =
        graphql_data(conn, query, variables)
        |> Map.get("createSubscriptionProduct")
        |> Map.get("subscriptionProduct")

      %{name: name} = params
      assert %{"id" => id, "name" => ^name} = data
      assert {:ok, _product} = Shops.find_subscription_product(shop, %{id: id})
    end
  end

  describe "updateSubscriptionProduct mutation" do
    setup %{conn: conn} do
      {:ok, owner} = Fixtures.owner() |> Accounts.insert_owner()
      {:ok, shop} = Shops.insert_shop(owner, Fixtures.shop())
      {:ok, product} = Shops.insert_subscription_product(shop, Fixtures.subscription_product())
      {:ok, token} = Accounts.token_from_owner(owner)
      conn = conn |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, shop: shop, product: product, params: Fixtures.subscription_product()}
    end

    test "updates subscription product", %{
      conn: conn,
      shop: shop,
      product: product,
      params: params
    } do
      query = """
        mutation ($input: UpdateSubscriptionProductInput!) {
          updateSubscriptionProduct(input: $input) {
            subscriptionProduct {
              id
              name
            }
          }
        }
      """

      variables = %{input: Map.put(params, :subscription_product_id, product.id)}

      data =
        graphql_data(conn, query, variables)
        |> Map.get("updateSubscriptionProduct")
        |> Map.get("subscriptionProduct")

      %{name: name} = params
      assert %{"name" => ^name} = data
      assert {:ok, %{name: ^name}} = Shops.find_subscription_product(shop, %{id: product.id})
    end
  end
end
