defmodule APIWeb.Schema.ShopTypes do
  use Absinthe.Schema.Notation

  object :shop_mutations do
    field :create_shop, :shop do
      middleware APIWeb.AuthMiddleware

      arg :name, non_null(:string)

      resolve &APIWeb.ShopResolver.create_shop/2
    end
  end

  object :shop do
    field :id, :id
    field :name, non_null(:string)
  end
end
