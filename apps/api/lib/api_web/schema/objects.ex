defmodule APIWeb.Schema.Objects do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :shop, :shop do
      resolve &APIWeb.ShopResolver.find_shop/3
    end
  end

  object :auth_token do
    field :token, :string
  end

  object :shop do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end
end
