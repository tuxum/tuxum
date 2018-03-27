defmodule APIWeb.Schema.Objects do
  use Absinthe.Schema.Notation

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
    field :onetime_products, list_of(:onetime_product) do
      resolve &APIWeb.OnetimeProductResolver.list_onetime_products/3
    end
  end

  object :onetime_product do
    field :id, non_null(:id)
    field :shop_id, non_null(:id)
    field :name, non_null(:string)
    field :is_public, non_null(:boolean)
    field :price, non_null(:money_with_currency)
    field :shipping_fee, :money_with_currency
  end

  object :money_with_currency do
    field :currency, non_null(:string)
    field :amount, non_null(:string)
  end
end
