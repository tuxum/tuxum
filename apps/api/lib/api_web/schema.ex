defmodule APIWeb.Schema do
  use Absinthe.Schema

  query do
    @desc "First query"
    field :user, :user do
      middleware APIWeb.AuthMiddleware

      resolve fn _args, resolution ->
        %{current_user: current_user} = resolution.context

        {:ok, current_user}
      end
    end

    mutation do
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
  end

  object :user do
    field :name, :string
  end

  object :auth_token do
    field :token, :string
  end
end
