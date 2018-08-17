defmodule APIWeb.Schema.SubscriptionProductTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :subscription_product_mutations do
    payload field(:create_subscription_product) do
      middleware APIWeb.AuthMiddleware

      input do
        field :name, non_null(:string)
        field :is_public, non_null(:boolean)
        field :price, non_null(:money_with_currency)
        field :setup_fee, :money_with_currency
      end

      output do
        field :subscription_product, non_null(:subscription_product)
      end

      resolve &APIWeb.SubscriptionProductResolver.create_subscription_product/2
    end

    payload field(:update_subscription_product) do
      middleware APIWeb.AuthMiddleware

      input do
        field :subscription_product_id, non_null(:id)
        field :name, non_null(:string)
        field :is_public, non_null(:boolean)
        field :price, non_null(:money_with_currency)
        field :setup_fee, :money_with_currency
      end

      output do
        field :subscription_product, non_null(:subscription_product)
      end

      resolve &APIWeb.SubscriptionProductResolver.update_subscription_product/2
    end
  end
end
