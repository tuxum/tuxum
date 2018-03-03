defmodule APIWeb.OnetimeProductResolver do
  alias Core.Shops

  def find_onetime_product(shop, %{onetime_product_id: id}, _resolution) do
    Shops.find_onetime_product(shop, %{id: id})
  end

  def create_onetime_product(%{shop_id: shop_id, input: params}, resolution) do
    %{current_user: current_user} = resolution.context

    with shop when shop != nil <- Shops.find_shop(current_user),
         {:ok, product} <- Shops.insert_onetime_product(shop, params) do
      {:ok, product}
    else
      {:error, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
      _ ->
        {:error, "Not Found"}
    end
  end

  def update_onetime_product(%{product_id: product_id, input: params}, resolution) do
    %{current_user: current_user} = resolution.context

    with shop when shop != nil <- Shops.find_shop(current_user),
         {:ok, product} <- Shops.find_onetime_product(shop, %{id: product_id}),
         {:ok, product} <- Shops.update_onetime_product(product, params) do
      {:ok, product}
    else
      {:error, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
      _ ->
        {:error, "Not Found"}
    end
  end
end
