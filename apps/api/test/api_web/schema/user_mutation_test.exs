defmodule APIWeb.Schema.UserMutationTest do
  use APIWeb.ConnCase, async: true

  describe "authenticate mutation" do
    setup do
      Core.Identities.insert_user(%{
        name: "John Doe",
        email: "john@doe.com",
        password: "s3cr3tp@ssw0rd"
      })
    end

    test "returns token if email/pass are correct", %{conn: conn} do
      query = """
        mutation {
          authenticate(email: "john@doe.com", password: "s3cr3tp@ssw0rd") {
            token
          }
        }
      """

      assert %{"authenticate" => %{"token" => _}} = graphql_data(conn, query)
    end

    test "returns token if email/pass are not correct", %{conn: conn} do
      query = """
        mutation {
          authenticate(email: "john@doe.com", password: "d1ff3r3ntp@ssw0rd") {
            token
          }
        }
      """

      [error | _] = graphql_errors(conn, query)

      assert %{"message" => "Unauthorized"} = error
    end
  end

  describe "createUser mutation" do
    test "inserts new user", %{conn: conn} do
      query = """
        mutation {
          createUser(name: "John Doe", email: "john@doe.com", password: "s3cr3tp@ssw0rd") {
            name
          }
        }
      """

      data = graphql_data(conn, query)

      assert %{"createUser" => %{"name" => "John Doe"}} = data
      assert Core.Identities.find_user(%{email: "john@doe.com"})
    end

    test "errors when invalid data given", %{conn: conn} do
      query = """
        mutation {
          createUser(name: "John Doe", email: "john@doe.com", password: "s3cr3t") {
            name
          }
        }
      """

      [error | _] = graphql_errors(conn, query)

      assert %{"message" => _} = error
      refute Core.Identities.find_user(%{email: "john@doe.com"})
    end
  end
end
