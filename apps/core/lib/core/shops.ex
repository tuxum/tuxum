defmodule Core.Shops do
  @moduledoc """
  Provides functionality to manage shops
  """

  import Ecto
  import Ecto.Query

  alias Core.Shops.{Shop, OnetimeProduct}
  alias Core.Identities.{User}

  def find_shop(%User{id: id}) do
    repo = DB.replica()

    from(s in Shop, where: s.user_id == ^id) |> repo.one
  end

  def insert_shop(user = %User{}, attrs) do
    repo = DB.primary()

    user
    |> Ecto.build_assoc(:shop)
    |> Shop.changeset(attrs)
    |> repo.insert()
  end

  def update_shop(user = %User{}, attrs) do
    user
    |> Ecto.assoc(:shop)
    |> DB.replica().one()
    |> case do
      nil ->
        {:error, :not_found}
      shop ->
        shop
        |> Shop.changeset(attrs)
        |> DB.primary().update()
    end
  end

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

  def insert_onetime_product(shop = %Shop{}, attrs) do
    attrs = transform_money(attrs)

    shop
    |> Ecto.build_assoc(:onetime_products)
    |> OnetimeProduct.changeset(attrs)
    |> DB.primary().insert()
  end

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
