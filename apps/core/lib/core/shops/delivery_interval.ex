defmodule Core.Shops.DeliveryInterval do
  use Core.Schema

  schema "delivery_intervals" do
    field :name, :string
    field :interval_days, :integer
  end
end
