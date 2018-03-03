defmodule Core.ProductsTest do
  use Core.DataCase, async: true

  alias Core.{Shops, Products, Identities, Fixtures}

  def insert_user(_) do
    {:ok, user} = Identities.insert_user(Fixtures.user())
    %{user: user}
  end

  def insert_shop(%{user: user}) do
    {:ok, shop} = Shops.insert_shop(user, Fixtures.shop())
    %{shop: shop}
  end

  describe "insert_onetime_product/2" do
    setup [:insert_user, :insert_shop]

    test "inserts a onetime product", %{shop: shop} do
      params = Fixtures.onetime_product()
      {:ok, product} = Products.insert_onetime_product(shop, params)

      assert product.name == params.name
      assert product.is_public == params.is_public
    end
  end
end
