defmodule APIWeb.UserResolver do
  def create_user(params = %{name: _, email: _, password: _}, _resolution) do
    case Core.Identities.insert_user(params) do
      {:ok, %{user: user}} ->
        {:ok, user}
      {:error, _, _, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
    end
  end
end
