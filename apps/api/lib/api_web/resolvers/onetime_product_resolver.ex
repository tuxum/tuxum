defmodule APIWeb.OnetimeProductResolver do

  alias Core.{Shops, Products}

  def find_onetime_product(shop, %{onetime_product_id: id}, _resolution) do
    Products.find_onetime_product(shop, %{id: id})
  end

  def create_onetime_product(%{shop_id: shop_id, input: params}, resolution) do
    %{current_user: current_user} = resolution.context

    with {:ok, shop} <- Shops.find_shop(current_user),
         {:ok, product} <- Products.insert_onetime_product(shop, params) do
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

    with {:ok, shop} <- Shops.find_shop(current_user),
         {:ok, product} <- Products.find_onetime_product(shop, %{id: product_id}),
         {:ok, product} <- Products.update_onetime_product(product, params) do
      {:ok, product}
    else
      {:error, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
      _ ->
        {:error, "Not Found"}
    end
  end
end
