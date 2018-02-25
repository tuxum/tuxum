defmodule APIWeb.ShopResolver do
  alias Core.Shops

  def create_shop(params = %{name: _}, resolution) do
    %{current_user: current_user} = resolution.context

    case Shops.insert_shop(current_user, params) do
      {:ok, shop} ->
        {:ok, shop}
      {:error, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
    end
  end

  def find_shop(user, _args, _resolution) do
    case Shops.find_shop(%{user_id: user.id}) do
      nil ->
        {:error, "Not Found"}
      shop ->
        {:ok, shop}
    end
  end
end
