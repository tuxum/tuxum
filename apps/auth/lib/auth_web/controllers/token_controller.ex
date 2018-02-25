defmodule AuthWeb.TokenController do
  use AuthWeb, :controller

  action_fallback AuthWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    identities_module = Application.get_env(:auth, :identities_module)

    with user when user != nil <- identities_module.authenticate(email, password),
         {:ok, token} <- identities_module.token_from_user(user) do
      conn
      |> put_status(:created)
      |> render("show.json", token: token)
    else
      _ -> {:error, :unauthorized}
    end
  end
end
