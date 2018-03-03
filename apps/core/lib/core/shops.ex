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

  @spec find_onetime_product(Shop.t(), map()) ::
    {:ok, OnetimeProduct.t()} |
    {:error, :not_found}
  def find_onetime_product(shop = %Shop{}, %{id: id}) do
    shop
    |> assoc(:onetime_products)
    |> where([p], p.id == ^id)
    |> DB.replica().one()
    |> case do
      nil ->
        {:error, :not_found}
      product ->
        {:ok, product}
    end
  end

  @spec insert_onetime_product(Shop.t(), map()) ::
    {:ok, OnetimeProduct.t()} |
    {:error, Ecto.Changeset.t()}
  def insert_onetime_product(shop = %Shop{}, attrs) do
    attrs = transform_money(attrs)

    shop
    |> build_assoc(:onetime_products)
    |> OnetimeProduct.changeset(attrs)
    |> DB.primary().insert()
  end

  @spec update_onetime_product(OnetimeProduct.t(), map()) ::
    {:ok, OnetimeProduct.t()} |
    {:error, Ecto.Changeset.t()}
  def update_onetime_product(product = %OnetimeProduct{}, attrs) do
    attrs = transform_money(attrs)

    product
    |> OnetimeProduct.changeset(attrs)
    |> DB.primary().update()
  end

  defp transform_money(attrs) do
    attrs
    |> Enum.map(&do_transform_money/1)
    |> Enum.into(%{})
  end

  defp do_transform_money({key, %{currency: currency, amount: amount}}) do
    {:ok, money} = %{"currency" => currency, "amount" => amount}
      |> Money.Ecto.Map.Type.load

    {key, money}
  end
  defp do_transform_money(pair), do: pair
end
