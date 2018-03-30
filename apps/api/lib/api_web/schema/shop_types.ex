defmodule APIWeb.Schema.ShopTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :shop_mutations do
    payload field :update_shop do
      middleware APIWeb.AuthMiddleware

      input do
        field :name, non_null(:string)
      end
      output do
        field :shop, non_null(:shop)
      end

      resolve &APIWeb.ShopResolver.update_shop/2
    end
  end
end
