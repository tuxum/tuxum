defmodule APIWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  import_types APIWeb.Schema.Objects

  import_types APIWeb.Schema.OwnerTypes
  import_types APIWeb.Schema.ShopTypes
  import_types APIWeb.Schema.CustomerTypes
  import_types APIWeb.Schema.OnetimeProductTypes
  import_types APIWeb.Schema.SubscriptionProductTypes

  query do
    import_fields :owner_queries
    import_fields :shop_queries
  end

  mutation do
    import_fields :owner_mutations
    import_fields :shop_mutations
    import_fields :customer_mutations
    import_fields :onetime_product_mutations
    import_fields :subscription_product_mutations
  end
end
