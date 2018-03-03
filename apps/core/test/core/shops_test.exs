defmodule Core.ShopsTest do
  use Core.DataCase, async: true

  alias Core.{Identities, Shops, Fixtures}

  def insert_user(_) do
    {:ok, user} = Identities.insert_user(Fixtures.user())
    %{user: user}
  end

  def insert_shop(%{user: user}) do
    {:ok, shop} = Shops.insert_shop(user, Fixtures.shop())
    %{shop: shop}
  end

  describe "find_shop/1" do
    setup [:insert_user, :insert_shop]

    test "finds a shop by user", %{user: user} do
      assert Shops.find_shop(user)
    end
  end

  describe "insert_shop/2" do
    setup [:insert_user]

    test "inserts a shop", %{user: user} do
      params = Fixtures.shop()
      {:ok, shop} = Shops.insert_shop(user, params)

      assert shop.name == params.name
    end

    test "requires a name", %{user: user} do
      params = Fixtures.shop() |> Map.put(:name, "")

      assert {:error, _} = Shops.insert_shop(user, params)
    end

    test "cannot insert twice", %{user: user} do
      params = Fixtures.shop()

      assert {:ok, _shop} = Shops.insert_shop(user, params)
      assert {:error, _} = Shops.insert_shop(user, params)
    end
  end

  describe "update_shop/2" do
    setup [:insert_user, :insert_shop]

    test "updates the user's shop", %{user: user} do
      {:ok, shop} = Shops.update_shop(user, %{name: "New Name"})

      assert shop.name == "New Name"
    end

    test "returns error if the user doesn't have shop" do
      {:ok, user} = Fixtures.user()
        |> Identities.insert_user()

      {:error, :not_found} = Shops.update_shop(user, Fixtures.shop())
    end
  end
end
