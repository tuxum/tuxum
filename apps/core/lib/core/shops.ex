defmodule Core.Shops do
  @moduledoc """
  Provides functionality to manage shops
  """

  import Ecto.Query, only: [from: 2]

  alias Core.Shops.Shop

  def find_shop(user, %{id: id}) do
    repo = DB.replica()

    from(s in Shop, where: s.user_id == ^user.id and s.id == ^id) |> repo.one
  end

  def insert_shop(user, %{name: name}) do
    repo = DB.primary()

    user
    |> Ecto.build_assoc(:shops)
    |> Shop.changeset(%{name: name})
    |> repo.insert
  end
end
