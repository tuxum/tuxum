defmodule AuthWeb.TokenControllerTest do
  use AuthWeb.ConnCase, async: true

  setup %{conn: conn} do
    conn = conn
      |> put_req_header("accept", "application/json")

    %{conn: conn}
  end

  describe "create action" do
    test "renders token when data are valid", %{conn: conn} do
      MockIdentities
      |> Mox.expect(:authenticate, fn "john@doe.com", "p@ssw0rd" -> %{id: 1} end)
      |> Mox.expect(:token_from_user, fn _ -> {:ok, "dummy.token"} end)

      json = conn
        |> post(token_path(conn, :create), %{email: "john@doe.com", password: "p@ssw0rd"})
        |> json_response(201)

      assert %{"token" => "dummy.token"} = json
    end

    test "renders error when given params are invalid", %{conn: conn} do
      MockIdentities
      |> Mox.expect(:authenticate, fn _, _ -> nil end)

      json = conn
        |> post(token_path(conn, :create), %{email: "john@doe.com", password: "p@ssw0rd"})
        |> json_response(401)

      assert %{"errors" => _} = json
    end
  end
end
