defmodule APIWeb.Schema.UserMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Fixtures}

  describe "authenticate mutation" do
    setup do
      params = Fixtures.user()
      {:ok, user} = Identities.insert_user(params)

      %{user: user, params: params}
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

  describe "createUser mutation" do
    setup do
      %{params: Fixtures.user()}
    end

    test "inserts new user", %{conn: conn, params: params = %{name: name}} do
      query = """
        mutation ($input: CreateUserInput!) {
          createUser(input: $input) {
            user {
              name
            }
          }
        }
      """
      variables = %{input: params}

      data = graphql_data(conn, query, variables)
        |> Map.get("createUser")
        |> Map.get("user")

      assert %{"name" => ^name} = data
      assert {:ok, _user} = Identities.find_user(%{email: params.email})
    end

    test "errors when invalid data given", %{conn: conn, params: params} do
      query = """
        mutation ($input: CreateUserInput!) {
          createUser(input: $input) {
            user {
              name
            }
          }
        }
      """
      variables = %{input: %{params | name: ""}}

      [error | _] = graphql_errors(conn, query, variables)

      assert %{"message" => _} = error
      assert {:error, :not_found} = Identities.find_user(%{email: params.email})
    end
  end
end
