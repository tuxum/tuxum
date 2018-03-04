defmodule APIWeb.ShopResolver do
  alias Core.Shops

  def find_shop(user, _args, _resolution) do
    case Shops.find_shop(user) do
      {:ok, shop} ->
        {:ok, shop}
      _ ->
        {:error, "Not Found"}
    end
  end

  def create_shop(%{input: params = %{name: _}}, resolution) do
    %{current_user: current_user} = resolution.context

    case Shops.insert_shop(current_user, params) do
      {:ok, shop} ->
        {:ok, %{shop: shop}}
      {:error, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
    end
  end

  def update_shop(%{input: params = %{name: _}}, resolution) do
    %{current_user: current_user} = resolution.context

    case Shops.update_shop(current_user, params) do
      {:ok, shop} ->
        {:ok, %{shop: shop}}
      {:error, :not_found} ->
        {:error, "Not Found"} # TODO: Return good error messages
    end
  end
end
