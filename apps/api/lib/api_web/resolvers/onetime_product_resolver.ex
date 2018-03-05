defmodule APIWeb.OnetimeProductResolver do

  alias Core.Shops
  alias Core.Shops.Shop

  def find_onetime_product(shop = %Shop{}, %{onetime_product_id: id}, _resolution) do
    Shops.find_onetime_product(shop, %{id: id})
  end

  def list_onetime_products(shop = %Shop{}, _args, _resolution) do
    Shops.list_onetime_products(shop)
  end

  def create_onetime_product(%{input: params}, resolution) do
    %{current_shop: shop} = resolution.context

    case Shops.insert_onetime_product(shop, params) do
      {:ok, product} ->
        {:ok, %{onetime_product: product}}
      error ->
        error
    end
  end

  def update_onetime_product(%{input: params}, resolution) do
    %{current_shop: shop} = resolution.context
    {product_id, params} = Map.pop(params, :onetime_product_id)

    case Shops.update_onetime_product(shop, product_id, params) do
      {:ok, product} ->
        {:ok, %{onetime_product: product}}
      error ->
        error
    end
  end
end
