defmodule APIWeb.Schema.UserMutationTest do
  use APIWeb.ConnCase, async: true

  describe "createUser mutation" do
    test "inserts new user", %{conn: conn} do
      query = """
      mutation {
        createUser(name: "John Doe", email: "john@doe.com", password: "s3cr3tp@ssw0rd") {
          name
        }
      }
      """

      json = conn
        |> post("/graphql", %{query: query})
        |> json_response(200)
        |> Map.get("data")

      assert %{"createUser" => %{"name" => "John Doe"}} = json
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

      [error | _] = conn
        |> post("/graphql", %{query: query})
        |> json_response(200)
        |> Map.get("errors")

      assert %{"message" => _} = error
      refute Core.Identities.find_user(%{email: "john@doe.com"})
    end
  end
end
