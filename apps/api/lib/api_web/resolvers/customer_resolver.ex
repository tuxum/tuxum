defmodule APIWeb.CustomerResolver do

  alias Core.Shops
  alias Core.Shops.Shop

  def find_customer(shop = %Shop{}, %{customer_id: id}, _resolution) do
    Shops.find_customer(shop, %{id: id})
  end

  def list_customers(shop = %Shop{}, args, _resolution) do
    {:ok, customers} = Shops.list_customers(shop)
    Absinthe.Relay.Connection.from_list(customers, args)
  end

  def create_customer(input, resolution) do
    %{current_shop: shop} = resolution.context

    case Shops.insert_customer(shop, input) do
      {:ok, customer} ->
        {:ok, %{customer: customer}}
      error ->
        error
    end
  end

  def update_customer(input, resolution) do
    %{current_shop: shop} = resolution.context
    {customer_id, params} = Map.pop(input, :customer_id)

    case Shops.update_customer(shop, customer_id, params) do
      {:ok, customer} ->
        {:ok, %{customer: customer}}
      error ->
        error
    end
  end
end
