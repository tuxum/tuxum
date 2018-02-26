defmodule APIWeb.Schema.UserMutationTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Fixtures}

  describe "authenticate mutation" do
    setup do
      params = Fixtures.user()
      user = Identities.insert_user(params)

      %{user: user, params: params}
    end

    test "returns token if email/pass are correct", %{conn: conn, params: params} do
      query = """
        mutation ($email: String!, $password: String!) {
          authenticate(email: $email, password: $password) {
            token
          }
        }
      """
      variables = Map.take(params, [:email, :password])

      assert %{"authenticate" => %{"token" => _}} = graphql_data(conn, query, variables)
    end

    test "returns token if email/pass are not correct", %{conn: conn, params: params} do
      query = """
        mutation ($email: String!, $password: String!) {
          authenticate(email: $email, password: $password) {
            token
          }
        }
      """

      [error | _] = graphql_errors(conn, query, %{email: params.email, password: "invalid"})

      assert %{"message" => "Unauthorized"} = error
    end
  end

  describe "createUser mutation" do
    setup do
      %{params: Fixtures.user()}
    end

    test "inserts new user", %{conn: conn, params: params} do
      query = """
        mutation ($name: String!, $email: String!, $password: String!) {
          createUser(name: $name, email: $email, password: $password) {
            name
          }
        }
      """

      data = graphql_data(conn, query, params)

      assert %{"createUser" => %{"name" => _}} = data
      assert Identities.find_user(%{email: params.email})
    end

    test "errors when invalid data given", %{conn: conn, params: params} do
      query = """
        mutation ($name: String!, $email: String!, $password: String!) {
          createUser(name: $name, email: $email, password: $password) {
            name
          }
        }
      """

      [error | _] = graphql_errors(conn, query, %{params | name: ""})

      assert %{"message" => _} = error
      refute Identities.find_user(%{email: params.email})
    end
  end
end
