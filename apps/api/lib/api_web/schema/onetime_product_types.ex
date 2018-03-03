defmodule APIWeb.Schema.OnetimeProductTypes do
  use Absinthe.Schema.Notation

  object :onetime_product_mutations do
    field :create_onetime_product, :onetime_product do
      middleware APIWeb.AuthMiddleware

      arg :shop_id, non_null(:id)
      arg :input, non_null(:create_onetime_product_input)

      resolve &APIWeb.OnetimeProductResolver.create_onetime_product/2
    end

    field :update_onetime_product, :onetime_product do
      middleware APIWeb.AuthMiddleware

      arg :product_id, non_null(:id)
      arg :input, non_null(:update_onetime_product_input)

      resolve &APIWeb.OnetimeProductResolver.update_onetime_product/2
    end
  end

  input_object :create_onetime_product_input do
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
    field :shipping_fee, :money_with_currency
  end

  input_object :update_onetime_product_input do
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
    field :shipping_fee, :money_with_currency
  end
end
