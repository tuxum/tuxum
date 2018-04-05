defmodule Core.Helpers do
  import Ecto.Query

  def find_by(queryable, condition) do
    queryable
    |> where(^condition)
    |> DB.replica().one()
    |> case do
      nil ->
        {:error, :not_found}
      resource ->
        {:ok, resource}
    end
  end

end
