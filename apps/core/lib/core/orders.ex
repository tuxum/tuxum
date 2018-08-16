defmodule Core.Orders do
  use Core

  alias Core.Orders.{
    Interval
  }

  def list_intervals do
    Interval |> DB.replica().all()
  end
end
