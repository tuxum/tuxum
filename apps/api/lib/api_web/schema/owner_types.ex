defmodule APIWeb.Schema.OwnerTypes do
  use Absinthe.Schema.Notation

  object :owner_queries do
    field :owner, :owner do
      middleware APIWeb.AuthMiddleware

      resolve fn _args, resolution ->
        %{current_owner: current_owner} = resolution.context

        {:ok, current_owner}
      end
    end
  end

  object :owner_mutations do
    field :authenticate, :authenticate_payload do
      arg :input, non_null(:authenticate_input)

      resolve &APIWeb.OwnerResolver.authenticate/2
    end

    field :signup, :signup_payload do
      arg :input, non_null(:signup_input)

      resolve &APIWeb.OwnerResolver.signup/2
    end
  end

  input_object :authenticate_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  object :authenticate_payload do
    field :token, :string
  end

  input_object :signup_input do
    field :owner, non_null(:signup_input_owner)
    field :shop, non_null(:signup_input_shop)
  end

  input_object :signup_input_owner do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  input_object :signup_input_shop do
    field :name, non_null(:string)
  end

  object :signup_payload do
    field :owner, non_null(:owner)
  end
end
