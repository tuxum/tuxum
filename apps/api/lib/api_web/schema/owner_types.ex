defmodule APIWeb.Schema.OwnerTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

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
    payload field :authenticate do
      input do
        field :email, non_null(:string)
        field :password, non_null(:string)
      end
      output do
        field :token, :string
      end

      resolve &APIWeb.OwnerResolver.authenticate/2
    end

    payload field :signup do
      input do
        field :owner, non_null(:signup_input_owner)
        field :shop, non_null(:signup_input_shop)
      end
      output do
        field :owner, non_null(:owner)
      end

      resolve &APIWeb.OwnerResolver.signup/2
    end
  end

  input_object :signup_input_owner do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  input_object :signup_input_shop do
    field :name, non_null(:string)
  end
end
