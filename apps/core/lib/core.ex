defmodule Core do

  alias Core.{Shops, Identities}

  def signup(%{owner: owner_params, shop: shop_params}) do
    with {:ok, owner} <- Identities.insert_owner(owner_params),
         {:ok, shop} <- Shops.insert_shop(owner, shop_params) do
      {:ok, %{owner: owner, shop: shop}}
    else
      _ ->
        {:error, "Something went wrong"}
    end
  end
end
