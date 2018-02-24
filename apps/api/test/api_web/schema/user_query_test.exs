defmodule APIWeb.Schema.UserQueryTest do
  use APIWeb.ConnCase, async: true

  describe "querying a user" do
    setup %{conn: conn} do
      {:ok, %{user: user}} = Core.Identities.insert_user(%{
        name: "John Doe",
        email: "john@doe.com",
        password: "s3cr3tp@ssw0rd"
      })

      {:ok, token} = Core.Identities.token_from_user(user)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, user: user}
    end

    test "get user information", %{conn: conn, user: %{name: name}} do
      json = conn
        |> post("/graphql", %{query: "query { user { name } }"})
        |> json_response(200)
        |> Map.get("data")

      assert %{"user" => %{"name" => ^name}} = json
    end

    test "returns error when token is missing", %{conn: conn} do
      [error | _] = conn
        |> delete_req_header("authorization")
        |> post("/graphql", %{query: "query { user { name } }"})
        |> json_response(200)
        |> Map.get("errors")

      assert %{"message" => "unauthorized"} = error
    end
  end
end
