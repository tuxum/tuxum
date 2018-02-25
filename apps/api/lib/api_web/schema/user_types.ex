defmodule APIWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation

  object :user_queries do
    field :user, :user do
      middleware APIWeb.AuthMiddleware

      resolve fn _args, resolution ->
        %{current_user: current_user} = resolution.context

        {:ok, current_user}
      end
    end
  end

  object :user_mutations do
    field :authenticate, :auth_token do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &APIWeb.UserResolver.authenticate/2
    end

    field :create_user, :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &APIWeb.UserResolver.create_user/2
    end
  end

  object :user do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :shop, :shop do
      resolve &APIWeb.ShopResolver.find_shop/3
    end
  end

  object :auth_token do
    field :token, :string
  end
end
