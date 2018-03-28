defmodule Core.Shops.DeliveryInterval do
  use Ecto.Schema

  schema "delivery_intervals" do
    field :name, :string
    field :interval_days, :integer
  end
end
