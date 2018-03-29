defmodule APIWeb.DeliveryIntervalProductResolver do

  alias Core.Shops
  alias Core.Shops.SubscriptionProduct

  def find_delivery_interval(product = %SubscriptionProduct{}, _args, _resolution) do
    Shops.find_delivery_interval(product)
  end
end
