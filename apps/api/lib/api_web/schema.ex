defmodule APIWeb.Schema do
  use Absinthe.Schema

  query do
    @desc "First query"
    field :user, :user do
      resolve fn _args, resolution ->
        %{current_user: current_user} = resolution.context

        {:ok, current_user}
      end
    end
  end

  object :user do
    field :name, :string
  end
end
