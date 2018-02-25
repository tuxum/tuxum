defmodule APIWeb.Schema do
  use Absinthe.Schema

  import_types APIWeb.Schema.UserTypes

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end
end
