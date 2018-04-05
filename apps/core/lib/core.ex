defmodule Core do

  alias Core.{Shops, Accounts}

  def signup(%{owner: owner_params, shop: shop_params}) do
    with {:ok, owner} <- Accounts.insert_owner(owner_params),
         {:ok, shop} <- Shops.insert_shop(owner, shop_params) do
      {:ok, %{owner: owner, shop: shop}}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
