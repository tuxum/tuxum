defmodule APIWeb.Schema.OwnerQueryTest do
  use APIWeb.ConnCase, async: true

  alias Core.{Identities, Fixtures}

  describe "querying a owner" do
    setup %{conn: conn} do
      {:ok, owner} = Fixtures.owner() |> Identities.insert_owner()

      {:ok, token} = Identities.token_from_owner(owner)
      conn = conn
        |> put_req_header("authorization", "Bearer #{token}")

      %{conn: conn, owner: owner}
    end

    test "get owner information", %{conn: conn, owner: %{name: name}} do
      data = graphql_data(conn, "query { owner { name } }")

      assert %{"owner" => %{"name" => ^name}} = data
    end

    test "returns error when token is missing", %{conn: conn} do
      [error | _] = conn
        |> delete_req_header("authorization")
        |> graphql_errors("query { owner { name } }")

      assert %{"message" => "unauthorized"} = error
    end
  end
end
