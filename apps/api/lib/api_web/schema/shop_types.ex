defmodule APIWeb.Schema.ShopTypes do
  use Absinthe.Schema.Notation

  object :shop_mutations do
    field :update_shop, :update_shop_payload do
      middleware APIWeb.AuthMiddleware

      arg :input, non_null(:update_shop_input)
      resolve &APIWeb.ShopResolver.update_shop/2
    end
  end

  input_object :update_shop_input do
    field :name, non_null(:string)
  end

  object :update_shop_payload do
    field :shop, non_null(:shop)
  end
end
