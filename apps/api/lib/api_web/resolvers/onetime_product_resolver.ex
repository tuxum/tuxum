defmodule APIWeb.OnetimeProductResolver do

  alias Core.Shops
  alias Core.Shops.Shop

  def find_onetime_product(shop = %Shop{}, %{onetime_product_id: id}, _resolution) do
    Shops.find_onetime_product(shop, %{id: id})
  end

  def list_onetime_products(shop = %Shop{}, args, _resolution) do
    {:ok, products} = Shops.list_onetime_products(shop)
    Absinthe.Relay.Connection.from_list(products, args)
  end

  def create_onetime_product(input, resolution) do
    %{current_shop: shop} = resolution.context

    case Shops.insert_onetime_product(shop, input) do
      {:ok, product} ->
        {:ok, %{onetime_product: product}}
      error ->
        error
    end
  end

  def update_onetime_product(input, resolution) do
    %{current_shop: shop} = resolution.context
    {product_id, params} = Map.pop(input, :onetime_product_id)

    case Shops.update_onetime_product(shop, product_id, params) do
      {:ok, product} ->
        {:ok, %{onetime_product: product}}
      error ->
        error
    end
  end
end
