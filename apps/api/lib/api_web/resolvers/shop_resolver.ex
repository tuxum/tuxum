defmodule APIWeb.ShopResolver do
  use APIWeb, :resolver

  alias Core.Shops

  def find_shop(_args, resolution) do
    case resolution.context do
      %{current_shop: shop} ->
        {:ok, shop}
      _ ->
        {:error, translate_errors(:not_found)}
    end
  end

  def create_shop(input = %{name: _}, resolution) do
    %{current_owner: current_owner} = resolution.context

    case Shops.insert_shop(current_owner, input) do
      {:ok, shop} ->
        {:ok, %{shop: shop}}
      {:error, changeset} ->
        {:error, translate_errors(changeset)}
    end
  end

  def update_shop(input = %{name: _}, resolution) do
    %{current_owner: current_owner} = resolution.context

    case Shops.update_shop(current_owner, input) do
      {:ok, shop} ->
        {:ok, %{shop: shop}}
      {:error, changeset} ->
        {:error, translate_errors(changeset)}
    end
  end
end
