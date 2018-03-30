defmodule APIWeb.ShopResolver do
  alias Core.Shops

  def find_shop(_args, resolution) do
    case resolution.context do
      %{current_shop: shop} ->
        {:ok, shop}
      _ ->
        {:error, "Not Found"}
    end
  end

  def create_shop(input = %{name: _}, resolution) do
    %{current_owner: current_owner} = resolution.context

    case Shops.insert_shop(current_owner, input) do
      {:ok, shop} ->
        {:ok, %{shop: shop}}
      {:error, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
    end
  end

  def update_shop(input = %{name: _}, resolution) do
    %{current_owner: current_owner} = resolution.context

    case Shops.update_shop(current_owner, input) do
      {:ok, shop} ->
        {:ok, %{shop: shop}}
      {:error, :not_found} ->
        {:error, "Not Found"} # TODO: Return good error messages
    end
  end
end
