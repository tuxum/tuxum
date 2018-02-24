defmodule APIWeb.Schema.UserQueryTest do
  use APIWeb.ConnCase, async: true

  test "user query", %{conn: conn} do
    json = conn
      |> post("/graphql", %{query: "query { user { name } }"})
      |> json_response(200)
      |> Map.get("data")

    assert json["user"]["name"] == "Bob"
  end
end
