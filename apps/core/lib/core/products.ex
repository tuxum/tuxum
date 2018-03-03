defmodule Core.Products do
  @moduledoc """
  Provides functionality to manage products
  """

  import Ecto
  import Ecto.Query

  alias Core.Shops.{Shop, OnetimeProduct}

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
