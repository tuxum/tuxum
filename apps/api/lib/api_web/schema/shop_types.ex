defmodule APIWeb.Schema.ShopTypes do
  use Absinthe.Schema.Notation

  object :shop_mutations do
    field :create_shop, :shop do
      middleware APIWeb.AuthMiddleware

      arg :name, non_null(:string)

      resolve &APIWeb.ShopResolver.create_shop/2
    end

    field :update_shop, :shop do
      middleware APIWeb.AuthMiddleware

      arg :name, non_null(:string)

      resolve &APIWeb.ShopResolver.update_shop/2
    end
  end
end
