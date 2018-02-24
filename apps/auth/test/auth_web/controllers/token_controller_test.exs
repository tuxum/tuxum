defmodule AuthWeb.TokenControllerTest do
  use AuthWeb.ConnCase

  setup %{conn: conn} do
    conn = conn
      |> put_req_header("accept", "application/json")

    %{conn: conn}
  end

  describe "create action" do
    test "renders token when data is valid", %{conn: conn} do
      json = conn
        |> post(token_path(conn, :create), %{email: "john@doe.com", password: "s3cr3tp@ssw0rd"})
        |> json_response(201)

      assert %{"token" => _} = json
    end
  end
end
