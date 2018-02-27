defmodule APIWeb.UserResolver do
  alias Core.Identities

  def create_user(%{input: params = %{name: _, email: _, password: _}}, _resolution) do
    case Identities.insert_user(params) do
      {:ok, %{user: user}} ->
        {:ok, user}
      {:error, _, _, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
    end
  end

  def authenticate(%{input: %{email: email, password: password}}, _resolution) do
    case Identities.authenticate(email, password) do
      nil ->
        {:error, "Unauthorized"}
      user ->
        {:ok, token} = Identities.token_from_user(user)
        {:ok, %{token: token}}
    end
  end
end
