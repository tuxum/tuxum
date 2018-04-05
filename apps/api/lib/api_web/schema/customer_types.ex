defmodule APIWeb.Schema.CustomerTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :customer_mutations do
    payload field :create_customer do
      middleware APIWeb.AuthMiddleware

      input do
        field :name, non_null(:string)
        field :email, non_null(:string)
        field :addresses, list_of(:address)
      end
      output do
        field :customer, non_null(:customer)
      end

      resolve &APIWeb.CustomerResolver.create_customer/2
    end

    payload field :update_customer do
      middleware APIWeb.AuthMiddleware

      input do
        field :customer_id, non_null(:id)
        field :name, non_null(:string)
        field :email, non_null(:string)
      end
      output do
        field :customer, non_null(:customer)
      end

      resolve &APIWeb.CustomerResolver.update_customer/2
    end
  end
end
