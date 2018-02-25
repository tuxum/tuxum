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

  describe "find_shop/1" do
    setup [:insert_user, :insert_shop]

    test "finds a shop by id", %{shop: shop} do
      assert Shops.find_shop(%{id: shop.id})
    end

    test "finds a shop by user id", %{user: user} do
      assert Shops.find_shop(%{user_id: user.id})
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

  describe "update_shop/2" do
    setup [:insert_user, :insert_shop]

    test "updates the user's shop", %{user: user} do
      {:ok, shop} = Shops.update_shop(user, %{name: "New Name"})

      assert shop.name == "New Name"
    end

    test "returns error if the user doesn't have shop" do
      {:ok, %{user: user}} = Identities.insert_user(%{
        name: "Mary Doe",
        email: "mary@doe.com",
        password: "s3cr3tp@ssw0rd"
      })

      {:error, :not_found} = Shops.update_shop(user, %{name: "New Name"})
    end
  end
end
