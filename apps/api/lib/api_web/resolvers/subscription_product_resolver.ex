defmodule APIWeb.SubscriptionProductResolver do

  alias Core.Shops
  alias Core.Shops.Shop

  def find_subscription_product(shop = %Shop{}, %{subscription_product_id: id}, _resolution) do
    Shops.find_subscription_product(shop, %{id: id})
  end

  def list_subscription_products(shop = %Shop{}, _args, _resolution) do
    Shops.list_subscription_products(shop)
  end

  def create_subscription_product(%{input: params}, resolution) do
    %{current_shop: shop} = resolution.context

    case Shops.insert_subscription_product(shop, params) do
      {:ok, product} ->
        {:ok, %{subscription_product: product}}
      error ->
        error
    end
  end

  def update_subscription_product(%{input: params}, resolution) do
    %{current_shop: shop} = resolution.context
    {product_id, params} = Map.pop(params, :subscription_product_id)

    case Shops.update_subscription_product(shop, product_id, params) do
      {:ok, product} ->
        {:ok, %{subscription_product: product}}
      error ->
        error
    end
  end
end
