defmodule APIWeb.Schema.OwnerMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Accounts, Fixtures}

  describe "authenticate mutation" do
    setup do
      params = Fixtures.owner()
      {:ok, owner} = Accounts.insert_owner(params)

      %{owner: owner, params: params}
    end

    test "returns token if email/pass are correct", %{conn: conn, params: params} do
      query = """
        mutation ($input: AuthenticateInput!) {
          authenticate(input: $input) {
            token
          }
        }
      """
      variables = %{input: Map.take(params, [:email, :password])}

      assert %{"authenticate" => %{"token" => _}} = graphql_data(conn, query, variables)
    end

    test "returns token if email/pass are not correct", %{conn: conn, params: params} do
      query = """
        mutation ($input: AuthenticateInput!) {
          authenticate(input: $input) {
            token
          }
        }
      """
      variables = %{input: %{email: params.email, password: "invalid"}}

      [error | _] = graphql_errors(conn, query, variables)

      assert %{"message" => "Unauthorized"} = error
    end
  end
end
