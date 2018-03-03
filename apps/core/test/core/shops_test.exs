defmodule Core.ShopsTest do
  use Core.DataCase, async: true

  alias Core.{Identities, Shops, Fixtures}

  @params Fixtures.shop()

  def insert_user(_) do
    Fixtures.user() |> Identities.insert_user()
  end

  def insert_shop(%{user: user}) do
    {:ok, shop} = Shops.insert_shop(user, @params)

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
      {:ok, shop} = Shops.insert_shop(user, @params)

      assert shop.name == @params.name
    end

    test "requires a name", %{user: user} do
      params = %{@params | name: ""}

      assert {:error, _} = Shops.insert_shop(user, params)
    end

    test "cannot insert twice", %{user: user} do
      assert {:ok, _shop} = Shops.insert_shop(user, @params)
      assert {:error, _} = Shops.insert_shop(user, @params)
    end
  end

  describe "update_shop/2" do
    setup [:insert_user, :insert_shop]

    test "updates the user's shop", %{user: user} do
      {:ok, shop} = Shops.update_shop(user, %{name: "New Name"})

      assert shop.name == "New Name"
    end

    test "returns error if the user doesn't have shop" do
      {:ok, %{user: user}} = Fixtures.user()
        |> Identities.insert_user()

      {:error, :not_found} = Shops.update_shop(user, Fixtures.shop())
    end
  end

  describe "insert_onetime_product/2" do
    setup [:insert_user, :insert_shop]

    test "inserts a onetime product", %{shop: shop} do
      params = Fixtures.onetime_product()
      {:ok, product} = Shops.insert_onetime_product(shop, params)

      assert product.name == params.name
      assert product.is_public == params.is_public
    end
  end
end
