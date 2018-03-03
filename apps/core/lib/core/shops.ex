defmodule Core.Shops do
  @moduledoc """
  Provides functionality to manage shops
  """

  import Ecto.Query, only: [from: 2]

  alias Core.Shops.{Shop, OnetimeProduct}

  def find_shop(%{id: id}) do
    repo = DB.replica()

    from(s in Shop, where: s.id == ^id) |> repo.one
  end

  def find_shop(%{user_id: user_id}) do
    repo = DB.replica()

    from(s in Shop, where: s.user_id == ^user_id) |> repo.one
  end

  def insert_shop(user, %{name: name}) do
    repo = DB.primary()

    user
    |> Ecto.build_assoc(:shop)
    |> Shop.changeset(%{name: name})
    |> repo.insert()
  end

  def update_shop(user, %{name: name}) do
    user
    |> Ecto.assoc(:shop)
    |> DB.replica().one()
    |> case do
      nil ->
        {:error, :not_found}
      shop ->
        shop
        |> Shop.changeset(%{name: name})
        |> DB.primary().update()
    end
  end

  def find_onetime_product(shop, %{id: id}) do
    from(p in Ecto.assoc(shop, :onetime_products), where: p.id == ^id)
    |> DB.replica().one()
    |> case do
      nil ->
        {:error, :not_found}
      product ->
        {:ok, product}
    end
  end

  def insert_onetime_product(shop, attrs) do
    attrs = transform_money(attrs)

    shop
    |> Ecto.build_assoc(:onetime_products)
    |> OnetimeProduct.changeset(attrs)
    |> DB.primary().insert()
  end

  def update_onetime_product(product, attrs) do
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
