defmodule AuthWeb.TokenController do
  use AuthWeb, :controller

  action_fallback AuthWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with user when user != nil <- Core.Identities.authorize(email, password),
         {:ok, token} <- Core.Identities.token_from_user(user) do
      conn
      |> put_status(:created)
      |> render("show.json", token: token)
    else
      _ -> {:error, :unauthorized}
    end
  end
end
