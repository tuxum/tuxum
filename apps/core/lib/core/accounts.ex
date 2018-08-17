defmodule Core.Accounts do
  @moduledoc """
  Module provides functionality around owner identities.
  """

  use Core

  alias Core.Accounts.{Owner, PasswordIdentity, Token}
  alias Core.Shops

  def find_owner(%{email: email}) do
    Owner |> find_by(email: email)
  end

  def find_owner(%{id: id}) do
    Owner |> find_by(id: id)
  end

  def signup(%{owner: owner_params, shop: shop_params}) do
    repo = DB.primary()

    repo.transaction(fn ->
      with {:ok, owner} <- insert_owner(owner_params),
           {:ok, shop} <- Shops.insert_shop(owner, shop_params) do
        %{owner: owner, shop: shop}
      else
        {:error, changeset} ->
          repo.rollback(changeset)
      end
    end)
  end

  def insert_owner(%{name: name, email: email, password: password}) do
    repo = DB.primary()

    repo.transaction(fn ->
      with {:ok, owner} <- %Owner{} |> Core.insert(%{name: name, email: email}),
           identity = owner |> Ecto.build_assoc(:password_identity),
           {:ok, password_identity} <- identity |> Core.insert(%{password: password}) do
        %Owner{owner | password_identity: password_identity}
      else
        {:error, changeset} ->
          repo.rollback(changeset)
      end
    end)
  end

  def authenticate(email, password) do
    with {:ok, owner} <- find_owner(%{email: email}),
         true <- correct_password?(owner, password) do
      {:ok, owner}
    else
      _ -> :error
    end
  end

  def correct_password?(owner, password) do
    repo = DB.replica()

    case repo.preload(owner, :password_identity) do
      %Owner{password_identity: identity = %PasswordIdentity{}} ->
        Comeonin.Pbkdf2.checkpw(password, identity.digest)

      _ ->
        false
    end
  end

  def owner_from_token(token) do
    case Token.to_owner(token) do
      nil -> :error
      owner -> {:ok, owner}
    end
  end

  def token_from_owner(owner) do
    {:ok, Token.from_owner(owner)}
  end
end
