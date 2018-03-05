defmodule APIWeb.Schema do
  use Absinthe.Schema

  import_types APIWeb.Schema.Objects

  import_types APIWeb.Schema.OwnerTypes
  import_types APIWeb.Schema.ShopTypes
  import_types APIWeb.Schema.OnetimeProductTypes

  query do
    import_fields :owner_queries
  end

  mutation do
    import_fields :owner_mutations
    import_fields :shop_mutations
    import_fields :onetime_product_mutations
  end
end
