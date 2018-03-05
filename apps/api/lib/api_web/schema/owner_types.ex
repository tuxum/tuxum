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

    field :create_owner, :create_owner_payload do
      arg :input, non_null(:create_owner_input)

      resolve &APIWeb.OwnerResolver.create_owner/2
    end
  end

  input_object :authenticate_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  object :authenticate_payload do
    field :token, :string
  end

  input_object :create_owner_input do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  object :create_owner_payload do
    field :owner, non_null(:owner)
  end
end
