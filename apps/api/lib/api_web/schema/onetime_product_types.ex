defmodule APIWeb.Schema.OnetimeProductTypes do
  use Absinthe.Schema.Notation

  object :onetime_product_mutations do
    field :create_onetime_product, :create_onetime_product_payload do
      middleware APIWeb.AuthMiddleware

      arg :input, non_null(:create_onetime_product_input)

      resolve &APIWeb.OnetimeProductResolver.create_onetime_product/2
    end

    field :update_onetime_product, :update_onetime_product_payload do
      middleware APIWeb.AuthMiddleware

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

  object :create_onetime_product_payload do
    field :onetime_product, non_null(:onetime_product)
  end

  input_object :update_onetime_product_input do
    field :onetime_product_id, non_null(:id)
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
    field :shipping_fee, :money_with_currency
  end

  object :update_onetime_product_payload do
    field :onetime_product, non_null(:onetime_product)
  end
end
