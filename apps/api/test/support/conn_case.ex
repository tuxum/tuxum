defmodule APIWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import APIWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint APIWeb.Endpoint

      def graphql_data(conn, query, variables \\ %{}) do
        conn
        |> post("/graphql", %{query: query, variables: variables})
        |> json_response(200)
        |> Map.get("data")
      end

      def graphql_errors(conn, query, variables \\ %{}) do
        conn
        |> post("/graphql", %{query: query, variables: variables})
        |> json_response(200)
        |> Map.get("errors")
      end
    end
  end

  setup tags do
    Enum.each(DB.repos(), fn repo ->
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(repo)

      unless tags[:async] do
        Ecto.Adapters.SQL.Sandbox.mode(repo, {:shared, self()})
      end
    end)

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
