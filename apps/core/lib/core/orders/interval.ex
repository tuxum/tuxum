defmodule Core.Orders.Interval do
  use Core.Schema

  schema "intervals" do
    field :count, :integer
    field :unit, :string
  end
end
