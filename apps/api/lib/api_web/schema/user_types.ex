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
      arg :input, non_null(:authenticate_input)

      resolve &APIWeb.UserResolver.authenticate/2
    end

    field :create_user, :user do
      arg :input, non_null(:create_user_input)

      resolve &APIWeb.UserResolver.create_user/2
    end
  end

  input_object :authenticate_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  input_object :create_user_input do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
  end
end
