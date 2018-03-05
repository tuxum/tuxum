defmodule APIWeb.OwnerResolver do
  alias Core.Identities

  def create_owner(%{input: params = %{name: _, email: _, password: _}}, _resolution) do
    case Identities.insert_owner(params) do
      {:ok, owner} ->
        {:ok, %{owner: owner}}
      {:error, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
    end
  end

  def authenticate(%{input: %{email: email, password: password}}, _resolution) do
    case Identities.authenticate(email, password) do
      {:ok, owner} ->
        {:ok, token} = Identities.token_from_owner(owner)
        {:ok, %{token: token}}
      _ ->
        {:error, "Unauthorized"}
    end
  end
end
