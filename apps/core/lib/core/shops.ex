defmodule Core.Shops do
  @moduledoc """
  Provides functionality to manage shops
  """

  import Ecto
  import Ecto.Query

  alias Core.Shops.{Shop, OnetimeProduct}
  alias Core.Identities.{User}

  @spec find_shop(User.t()) :: {:ok, Shop.t()} | {:error, :not_found}
  def find_shop(%User{id: id}) do
    Shop
    |> where([s], s.user_id == ^id)
    |> DB.replica().one()
    |> case do
      nil ->
        {:error, :not_found}
      user ->
        {:ok, user}
    end
  end

  @spec insert_shop(User.t(), map()) ::
    {:ok, Shop.t()} |
    {:error, Ecto.Changeset.t()}
  def insert_shop(user = %User{}, attrs) do
    user
    |> build_assoc(:shop)
    |> Shop.changeset(attrs)
    |> DB.primary().insert()
  end

  @spec update_shop(User.t(), map()) ::
    {:ok, Shop.t()} |
    {:error, Ecto.Changeset.t()} |
    {:error, :not_found}
  def update_shop(user = %User{}, attrs) do
    with {:ok, shop} <- find_shop(user) do
      shop
      |> Shop.changeset(attrs)
      |> DB.primary().update()
    else
      error -> error
    end
  end
end
