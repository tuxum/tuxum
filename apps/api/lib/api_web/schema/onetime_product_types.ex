defmodule APIWeb.Schema.OnetimeProductTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :onetime_product_mutations do
    payload field(:create_onetime_product) do
      middleware APIWeb.AuthMiddleware

      input do
        field :name, non_null(:string)
        field :is_public, non_null(:boolean)
        field :price, non_null(:money_with_currency)
        field :shipping_fee, :money_with_currency
      end

      output do
        field :onetime_product, non_null(:onetime_product)
      end

      resolve &APIWeb.OnetimeProductResolver.create_onetime_product/2
    end

    payload field(:update_onetime_product) do
      middleware APIWeb.AuthMiddleware

      input do
        field :onetime_product_id, non_null(:id)
        field :name, non_null(:string)
        field :is_public, non_null(:boolean)
        field :price, non_null(:money_with_currency)
        field :shipping_fee, :money_with_currency
      end

      output do
        field :onetime_product, non_null(:onetime_product)
      end

      resolve &APIWeb.OnetimeProductResolver.update_onetime_product/2
    end
  end
end
