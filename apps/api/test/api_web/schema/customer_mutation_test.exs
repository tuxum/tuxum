defmodule APIWeb.Schema.CustomerMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Accounts, Shops, Fixtures}

  describe "createCustomer mutation" do
    setup %{conn: conn} do
      {:ok, owner} = Fixtures.owner() |> Accounts.insert_owner()
      {:ok, shop} = Shops.insert_shop(owner, Fixtures.shop())
      {:ok, token} = Accounts.token_from_owner(owner)
      conn = conn |> put_req_header("authorization", "Bearer #{token}")

      params = Fixtures.customer()

      %{conn: conn, owner: owner, shop: shop, params: params}
    end

    test "inserts new onetime customer", %{conn: conn, shop: shop, params: params} do
      query = """
        mutation ($input: CreateCustomerInput!) {
          createCustomer(input: $input) {
            customer {
              id
              name
            }
          }
        }
      """
      variables = %{input: params}

      data = graphql_data(conn, query, variables)
        |> Map.get("createCustomer")
        |> Map.get("customer")

      %{name: name} = params
      assert %{"id" => id, "name" => ^name} = data
      assert {:ok, _customer} = Shops.find_customer(shop, %{id: id})
    end
  end

  describe "updateCustomer mutation" do
    setup %{conn: conn} do
      {:ok, owner} = Fixtures.owner() |> Accounts.insert_owner()
      {:ok, shop} = Shops.insert_shop(owner, Fixtures.shop())
      {:ok, customer} = Shops.insert_customer(shop, Fixtures.customer())
      {:ok, token} = Accounts.token_from_owner(owner)
      conn = conn |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, shop: shop, customer: customer, params: Fixtures.customer()}
    end

    test "updates onetime customer", %{conn: conn, shop: shop, customer: customer, params: params} do
      query = """
        mutation ($input: UpdateCustomerInput!) {
          updateCustomer(input: $input) {
            customer {
              id
              name
            }
          }
        }
      """
      variables = %{input: Map.put(params, :customer_id, customer.id)}

      data = graphql_data(conn, query, variables)
        |> Map.get("updateCustomer")
        |> Map.get("customer")

      %{name: name} = params
      assert %{"name" => ^name} = data
      assert {:ok, %{name: ^name}} = Shops.find_customer(shop, %{id: customer.id})
    end
  end
end
