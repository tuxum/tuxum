defmodule APIWeb.OwnerResolver do
  use APIWeb, :resolver

  alias Core.Accounts

  def signup(input = %{owner: _, shop: _}, _resolution) do
    case Core.signup(input) do
      {:ok, changes} ->
        {:ok, changes}
      {:error, changeset} ->
        {:error, translate_errors(changeset)}
    end
  end

  def authenticate(%{email: email, password: password}, _resolution) do
    case Accounts.authenticate(email, password) do
      {:ok, owner} ->
        {:ok, token} = Accounts.token_from_owner(owner)
        {:ok, %{token: token}}
      :error ->
        {:error, translate_errors(:unauthorized)}
    end
  end
end
