defmodule APIWeb.Schema do
  use Absinthe.Schema

  import_types APIWeb.Schema.Objects

  import_types APIWeb.Schema.UserTypes
  import_types APIWeb.Schema.ShopTypes

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :shop_mutations
  end
end
