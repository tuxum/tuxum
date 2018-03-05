defmodule APIWeb.Schema.OwnerMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Fixtures}

  describe "authenticate mutation" do
    setup do
      params = Fixtures.owner()
      {:ok, owner} = Identities.insert_owner(params)

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

  describe "createOwner mutation" do
    setup do
      %{params: Fixtures.owner()}
    end

    test "inserts new owner", %{conn: conn, params: params = %{name: name}} do
      query = """
        mutation ($input: CreateOwnerInput!) {
          createOwner(input: $input) {
            owner {
              name
            }
          }
        }
      """
      variables = %{input: params}

      data = graphql_data(conn, query, variables)
        |> Map.get("createOwner")
        |> Map.get("owner")

      assert %{"name" => ^name} = data
      assert {:ok, _owner} = Identities.find_owner(%{email: params.email})
    end

    test "errors when invalid data given", %{conn: conn, params: params} do
      query = """
        mutation ($input: CreateOwnerInput!) {
          createOwner(input: $input) {
            owner {
              name
            }
          }
        }
      """
      variables = %{input: %{params | name: ""}}

      [error | _] = graphql_errors(conn, query, variables)

      assert %{"message" => _} = error
      assert {:error, :not_found} = Identities.find_owner(%{email: params.email})
    end
  end
end
