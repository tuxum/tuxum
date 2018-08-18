defmodule Core.Shops do
  @moduledoc """
  Provides functionality to manage shops
  """

  use Core

  alias Core.Shops.{Shop, CustomerAddress}
  alias Core.Orders.Address
  alias Core.Accounts.Owner

  def find_shop(%Owner{id: id}) do
    Shop |> find_by(owner_id: id)
  end

  def insert_shop(owner = %Owner{}, attrs) do
    owner
    |> build_assoc(:shop)
    |> Core.insert(attrs)
  end

  def update_shop(owner = %Owner{}, attrs) do
    with {:ok, shop} <- find_shop(owner) do
      shop |> Core.update(attrs)
    else
      error -> error
    end
  end

  def find_customer(shop = %Shop{}, %{id: id}) do
    shop |> assoc(:customers) |> find_by(id: id)
  end

  def find_customer(shop = %Shop{}, %{email: email}) do
    shop |> assoc(:customers) |> find_by(email: email)
  end

  def list_customers(shop = %Shop{}, _opts \\ %{}) do
    customers =
      shop
      |> assoc(:customers)
      |> DB.replica().all()

    {:ok, customers}
  end

  def insert_customer(shop = %Shop{}, attrs) do
    repo = DB.primary()

    {address_attrs, attrs} = Map.pop(attrs, :addresses)

    repo.transaction(fn ->
      customer = shop |> build_assoc(:customers)

      with {:ok, customer} <- Core.insert(customer, attrs) do
        Enum.each(address_attrs, fn address ->
          with {:ok, address} <- %Address{} |> Core.insert(address),
               customer_address = %CustomerAddress{
                 customer_id: customer.id,
                 address_id: address.id
               },
               {:ok, _} <- Core.insert(customer_address, %{}) do
            nil
          else
            {:error, changeset} ->
              repo.rollback(changeset)
          end
        end)

        customer
      else
        {:error, changeset} ->
          repo.rollback(changeset)
      end
    end)
  end

  def update_customer(shop = %Shop{}, customer_id, attrs) do
    with {:ok, customer} <- find_customer(shop, %{id: customer_id}),
         {:ok, customer} <- Core.update(customer, attrs) do
      {:ok, customer}
    else
      error -> error
    end
  end

  def find_address(customer, %{id: id}) do
    customer |> assoc(:addresses) |> find_by(id: id)
  end

  def update_address(customer, address_id, attrs) do
    with {:ok, address} <- find_address(customer, %{id: address_id}),
         {:ok, address} <- Core.update(address, attrs) do
      {:ok, address}
    else
      error -> error
    end
  end

  def find_onetime_product(shop = %Shop{}, %{id: id}) do
    shop |> assoc(:onetime_products) |> find_by(id: id)
  end

  def list_onetime_products(shop = %Shop{}, _opts \\ %{}) do
    products =
      shop
      |> assoc(:onetime_products)
      |> DB.replica().all()

    {:ok, products}
  end

  def insert_onetime_product(shop = %Shop{}, attrs) do
    attrs = transform_money(attrs)

    shop
    |> build_assoc(:onetime_products)
    |> Core.insert(attrs)
  end

  def update_onetime_product(shop = %Shop{}, product_id, attrs) do
    with {:ok, product} <- find_onetime_product(shop, %{id: product_id}),
         {:ok, product} <- Core.update(product, attrs) do
      {:ok, product}
    else
      error -> error
    end
  end

  def find_subscription_product(shop = %Shop{}, %{id: id}) do
    shop |> assoc(:subscription_products) |> find_by(id: id)
  end

  def list_subscription_products(shop, _opts \\ %{}) do
    products =
      shop
      |> assoc(:subscription_products)
      |> DB.replica().all()

    {:ok, products}
  end

  def insert_subscription_product(shop = %Shop{}, attrs) do
    attrs = transform_money(attrs)

    shop
    |> build_assoc(:subscription_products)
    |> Core.insert(attrs)
  end

  def update_subscription_product(shop = %Shop{}, product_id, attrs) do
    with {:ok, product} <- find_subscription_product(shop, %{id: product_id}),
         {:ok, product} <- Core.update(product, attrs) do
      {:ok, product}
    else
      error -> error
    end
  end

  defp transform_money(attrs) do
    attrs
    |> Enum.map(&do_transform_money/1)
    |> Enum.into(%{})
  end

  defp do_transform_money({key, %{currency: currency, amount: amount}}) do
    {:ok, money} =
      %{"currency" => currency, "amount" => amount}
      |> Money.Ecto.Map.Type.load()

    {key, money}
  end

  defp do_transform_money(pair), do: pair
end
