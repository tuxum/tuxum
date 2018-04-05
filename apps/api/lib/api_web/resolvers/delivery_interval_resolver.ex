defmodule APIWeb.DeliveryIntervalProductResolver do
  use APIWeb, :resolver

  alias Core.Shops
  alias Core.Shops.SubscriptionProduct

  def find_delivery_interval(product = %SubscriptionProduct{}, _args, _resolution) do
    Shops.find_delivery_interval(product)
  end
end
