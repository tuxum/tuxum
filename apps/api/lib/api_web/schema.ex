defmodule APIWeb.Schema do
  use Absinthe.Schema

  query do
    @desc "First query"
    field :user, :user do
      resolve fn _, _, _ -> {:ok, %{name: "Bob"}} end
    end
  end

  object :user do
    field :name, :string
  end
end
