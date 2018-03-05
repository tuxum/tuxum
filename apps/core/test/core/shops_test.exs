defmodule Core.ShopsTest do
  use Core.DataCase, async: true

  alias Core.{Identities, Shops, Fixtures}

  def insert_owner(_) do
    {:ok, owner} = Identities.insert_owner(Fixtures.owner())
    %{owner: owner}
  end

  def insert_shop(%{owner: owner}) do
    {:ok, shop} = Shops.insert_shop(owner, Fixtures.shop())
    %{shop: shop}
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
        |> Identities.insert_owner()

      {:error, :not_found} = Shops.update_shop(owner, Fixtures.shop())
    end
  end
end
