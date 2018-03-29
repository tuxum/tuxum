defmodule Core.Shops do
  @moduledoc """
  Provides functionality to manage shops
  """

  import Ecto
  import Ecto.Query

  alias Core.Shops.{Shop, OnetimeProduct, SubscriptionProduct, DeliveryInterval}
  alias Core.Accounts.{Owner}

  def find_shop(%Owner{id: id}) do
    Shop
    |> where([s], s.owner_id == ^id)
    |> DB.replica().one()
    |> case do
      nil ->
        {:error, :not_found}
      owner ->
        {:ok, owner}
    end
  end

  def insert_shop(owner = %Owner{}, attrs) do
    owner
    |> build_assoc(:shop)
    |> Shop.insert(attrs)
  end

  def update_shop(owner = %Owner{}, attrs) do
    with {:ok, shop} <- find_shop(owner) do
      shop |> Shop.update(attrs)
    else
      error -> error
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

  def list_onetime_products(shop, _opts \\ %{}) do
    products = shop
      |> assoc(:onetime_products)
      |> DB.replica().all()

    {:ok, products}
  end

  def insert_onetime_product(shop = %Shop{}, attrs) do
    attrs = transform_money(attrs)

    shop
    |> build_assoc(:onetime_products)
    |> OnetimeProduct.insert(attrs)
    |> case do
      {:ok, product} ->
        {:ok, product}
      {:error, _changeset} ->
        {:error, ["Something went wrong"]}
    end
  end

  def update_onetime_product(shop = %Shop{}, product_id, attrs) do
    with {:ok, product} <- find_onetime_product(shop, %{id: product_id}),
         {:ok, product} <- OnetimeProduct.update(product, attrs) do
      {:ok, product}
    else
      {:error, _} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
      _ ->
        {:error, "Not Found"}
    end
  end

  def find_subscription_product(shop = %Shop{}, %{id: id}) do
    shop
    |> assoc(:subscription_products)
    |> where([p], p.id == ^id)
    |> DB.replica().one()
    |> case do
      nil ->
        {:error, :not_found}
      product ->
        {:ok, product}
    end
  end

  def list_subscription_products(shop, _opts \\ %{}) do
    products = shop
      |> assoc(:subscription_products)
      |> DB.replica().all()

    {:ok, products}
  end

  def insert_subscription_product(shop = %Shop{}, attrs) do
    attrs = transform_money(attrs)

    shop
    |> build_assoc(:subscription_products)
    |> SubscriptionProduct.insert(attrs)
    |> case do
      {:ok, product} ->
        {:ok, product}
      {:error, _changeset} ->
        {:error, ["Something went wrong"]}
    end
  end

  def update_subscription_product(shop = %Shop{}, product_id, attrs) do
    with {:ok, product} <- find_subscription_product(shop, %{id: product_id}),
         {:ok, product} <- SubscriptionProduct.update(product, attrs) do
      {:ok, product}
    else
      {:error, _changeset} ->
        {:error, "Something bad happen"} # TODO: Return good error messages
      _ ->
        {:error, "Not Found"}
    end
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

  def find_delivery_interval(%SubscriptionProduct{delivery_interval_id: id}) do
    DeliveryInterval
    |> DB.replica().get(id)
    |> case do
      nil ->
        {:error, :not_found}
      interval ->
        {:ok, interval}
    end
  end
end
