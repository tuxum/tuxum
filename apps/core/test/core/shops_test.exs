defmodule Core.ShopsTest do
  use Core.DataCase, async: true

  alias Core.{Identities, Shops}

  @params %{name: "My Shop"}

  def insert_user(_) do
    Identities.insert_user(%{
      name: "John Doe",
      email: "john@doe.com",
      password: "s3cr3tp@ssw0rd"
    })
  end

  def insert_shop(%{user: user}) do
    {:ok, shop} = Shops.insert_shop(user, @params)

    %{shop: shop}
  end

  describe "find_shop/2" do
    setup [:insert_user, :insert_shop]

    test "returns a shop", %{shop: shop, user: user} do
      assert Shops.find_shop(user, %{id: shop.id})
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
  end
end
