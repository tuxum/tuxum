defmodule APIWeb.SubscriptionProductResolver do
  use APIWeb, :resolver

  alias Core.Shops
  alias Core.Shops.Shop

  def find_subscription_product(shop = %Shop{}, %{subscription_product_id: id}, _resolution) do
    Shops.find_subscription_product(shop, %{id: id})
  end

  def list_subscription_products(shop = %Shop{}, args, _resolution) do
    {:ok, products} = Shops.list_subscription_products(shop)
    Absinthe.Relay.Connection.from_list(products, args)
  end

  def create_subscription_product(input, resolution) do
    %{current_shop: shop} = resolution.context

    case Shops.insert_subscription_product(shop, input) do
      {:ok, product} ->
        {:ok, %{subscription_product: product}}

      {:error, changeset} ->
        {:error, translate_errors(changeset)}
    end
  end

  def update_subscription_product(input, resolution) do
    %{current_shop: shop} = resolution.context
    {product_id, params} = Map.pop(input, :subscription_product_id)

    case Shops.update_subscription_product(shop, product_id, params) do
      {:ok, product} ->
        {:ok, %{subscription_product: product}}

      {:error, changeset} ->
        {:error, translate_errors(changeset)}
    end
  end
end
