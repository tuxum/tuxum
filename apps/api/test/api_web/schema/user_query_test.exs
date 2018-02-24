defmodule APIWeb.Schema.UserQueryTest do
  use APIWeb.ConnCase, async: true

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

  test "user query", %{conn: conn, user: %{name: name}} do
    json = conn
      |> post("/graphql", %{query: "query { user { name } }"})
      |> json_response(200)
      |> Map.get("data")

    assert %{"user" => %{"name" => ^name}} = json
  end
end
