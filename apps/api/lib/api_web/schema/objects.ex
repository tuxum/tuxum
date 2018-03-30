defmodule APIWeb.Schema.Objects do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :owner do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :shop, :shop do
      resolve &APIWeb.ShopResolver.find_shop/2
    end
  end

  object :shop do
    field :id, non_null(:id)
    field :name, non_null(:string)
    connection field :onetime_products, node_type: :onetime_product do
      resolve &APIWeb.OnetimeProductResolver.list_onetime_products/3
    end
    connection field :subscription_products, node_type: :subscription_product do
      resolve &APIWeb.SubscriptionProductResolver.list_subscription_products/3
    end
  end

  object :onetime_product do
    field :id, non_null(:id)
    field :shop_id, non_null(:id)
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
    field :shipping_fee, non_null(:money_with_currency)
  end

  connection node_type: :onetime_product

  object :subscription_product do
    field :id, non_null(:id)
    field :shop_id, non_null(:id)
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
    field :setup_fee, non_null(:money_with_currency)
    field :shipping_fee, non_null(:money_with_currency)
    field :delivery_interval, non_null(:delivery_interval) do
      resolve &APIWeb.DeliveryIntervalProductResolver.find_delivery_interval/3
    end
  end

  connection node_type: :subscription_product

  object :money_with_currency do
    field :currency, non_null(:string)
    field :amount, non_null(:string)
  end

  object :delivery_interval do
    field :name, non_null(:string)
    field :interval_days, non_null(:integer)
  end
end
