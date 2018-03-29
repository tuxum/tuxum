defmodule APIWeb.Schema.SubscriptionProductTypes do
  use Absinthe.Schema.Notation

  object :subscription_product_mutations do
    field :create_subscription_product, :create_subscription_product_payload do
      middleware APIWeb.AuthMiddleware

      arg :input, non_null(:create_subscription_product_input)
      resolve &APIWeb.SubscriptionProductResolver.create_subscription_product/2
    end

    field :update_subscription_product, :update_subscription_product_payload do
      middleware APIWeb.AuthMiddleware

      arg :input, non_null(:update_subscription_product_input)
      resolve &APIWeb.SubscriptionProductResolver.update_subscription_product/2
    end
  end

  input_object :create_subscription_product_input do
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
    field :setup_fee, :money_with_currency
    field :shipping_fee, :money_with_currency
    field :delivery_interval_id, non_null(:id)
  end

  object :create_subscription_product_payload do
    field :subscription_product, non_null(:subscription_product)
  end

  input_object :update_subscription_product_input do
    field :subscription_product_id, non_null(:id)
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
    field :setup_fee, :money_with_currency
    field :shipping_fee, :money_with_currency
    field :delivery_interval_id, non_null(:id)
  end

  object :update_subscription_product_payload do
    field :subscription_product, non_null(:subscription_product)
  end
end
