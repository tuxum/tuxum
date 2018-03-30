defmodule APIWeb.OwnerResolver do
  alias Core.Accounts

  def signup(input = %{owner: _, shop: _}, _resolution) do
    case Core.signup(input) do
      {:ok, changes} ->
        {:ok, changes}
      {:error, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
    end
  end

  def authenticate(%{email: email, password: password}, _resolution) do
    case Accounts.authenticate(email, password) do
      {:ok, owner} ->
        {:ok, token} = Accounts.token_from_owner(owner)
        {:ok, %{token: token}}
      _ ->
        {:error, "Unauthorized"}
    end
  end
end
