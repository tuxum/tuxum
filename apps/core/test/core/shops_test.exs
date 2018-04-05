defmodule Core.ShopsTest do
  use Core.DataCase, async: true

  alias Core.{Accounts, Shops, Fixtures}

  def insert_owner(_) do
    {:ok, owner} = Accounts.insert_owner(Fixtures.owner())
    %{owner: owner}
  end

  def insert_shop(%{owner: owner}) do
    {:ok, shop} = Shops.insert_shop(owner, Fixtures.shop())
    %{shop: shop}
  end

  def insert_customer(%{shop: shop}) do
    attrs = Fixtures.customer() |> Map.put(:addresses, [Fixtures.address()])
    {:ok, customer} = Shops.insert_customer(shop, attrs)

    %{customer: customer}
  end

  describe "find_shop/1" do
    setup [:insert_owner, :insert_shop]

    test "finds a shop by owner", %{owner: owner} do
      assert Shops.find_shop(owner)
    end
  end

  describe "insert_shop/2" do
    setup [:insert_owner]

    test "inserts a shop", %{owner: owner} do
      params = Fixtures.shop()
      {:ok, shop} = Shops.insert_shop(owner, params)

      assert shop.name == params.name
    end

    test "requires a name", %{owner: owner} do
      params = Fixtures.shop() |> Map.put(:name, "")

      assert {:error, _} = Shops.insert_shop(owner, params)
    end

    test "cannot insert twice", %{owner: owner} do
      params = Fixtures.shop()

      assert {:ok, _shop} = Shops.insert_shop(owner, params)
      assert {:error, _} = Shops.insert_shop(owner, params)
    end
  end

  describe "update_shop/2" do
    setup [:insert_owner, :insert_shop]

    test "updates the owner's shop", %{owner: owner} do
      {:ok, shop} = Shops.update_shop(owner, %{name: "New Name"})

      assert shop.name == "New Name"
    end

    test "returns error if the owner doesn't have shop" do
      {:ok, owner} = Fixtures.owner()
        |> Accounts.insert_owner()

      {:error, :not_found} = Shops.update_shop(owner, Fixtures.shop())
    end
  end

  describe "inserting customers" do
    setup [:insert_owner, :insert_shop]

    test "returns error when email is already registered", %{shop: shop} do
      params = Fixtures.customer()

      assert {:ok, _customer} = Shops.insert_customer(shop, params)
      assert {:error, _changeset} = Shops.insert_customer(shop, params)
    end

    test "returns changeset when invalid params given", %{shop: shop} do
      params = Fixtures.customer() |> Map.put(:name, "")

      assert {:error, _} = Shops.insert_customer(shop, params)

      addresses = Fixtures.address() |> Map.put(:name, "") |> List.wrap()
      params = Fixtures.customer() |> Map.put(:addresses, addresses)

      assert {:error, _} = Shops.insert_customer(shop, params)
    end
  end

  describe "update customer addresses" do
    setup [:insert_owner, :insert_shop, :insert_customer]

    test "can update existing one", %{customer: customer} do
      customer = customer |> DB.replica().preload(:addresses)
      address = customer.addresses |> List.first

      {:ok, address} = Shops.update_address(customer, address.id, %{country: "US"})

      assert address.country == "US"
    end
  end
end
