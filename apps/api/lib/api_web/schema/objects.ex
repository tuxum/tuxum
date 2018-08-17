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

    connection field :customers, node_type: :customer do
      resolve &APIWeb.CustomerResolver.list_customers/3
    end

    connection field :onetime_products, node_type: :onetime_product do
      resolve &APIWeb.OnetimeProductResolver.list_onetime_products/3
    end

    connection field :subscription_products, node_type: :subscription_product do
      resolve &APIWeb.SubscriptionProductResolver.list_subscription_products/3
    end
  end

  connection(node_type: :customer)
  connection(node_type: :onetime_product)
  connection(node_type: :subscription_product)

  object :customer do
    field :id, non_null(:id)
    field :shop_id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :addresses, list_of(:address)
  end

  object :address do
    field :label, :string
    field :name, non_null(:string)
    field :postal_code, non_null(:string)
    field :country, non_null(:string)
    field :district, non_null(:string)
    field :line1, non_null(:string)
    field :line2, :string
    field :line3, :string
    field :phone, non_null(:string)
  end

  object :onetime_product do
    field :id, non_null(:id)
    field :shop_id, non_null(:id)
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
  end

  object :subscription_product do
    field :id, non_null(:id)
    field :shop_id, non_null(:id)
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
    field :setup_fee, non_null(:money_with_currency)
  end

  object :money_with_currency do
    field :currency, non_null(:string)
    field :amount, non_null(:string)
  end
end
