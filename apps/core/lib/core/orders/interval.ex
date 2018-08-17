defmodule Core.Orders.Interval do
  use Core.Schema

  schema "intervals" do
    field :count, :integer
    field :unit, :string
  end

  @impl Core.Schema
  def insert_changeset(delivery_plan, attrs \\ %{}) do
    delivery_plan
    |> cast(attrs, ~w[count unit]a)
    |> validate_required(~w[count unit]a)
  end

  @impl Core.Schema
  def update_changeset(delivery_plan, attrs \\ %{}) do
    insert_changeset(delivery_plan, attrs)
  end
end
