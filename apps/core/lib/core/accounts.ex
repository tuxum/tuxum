defmodule Core.Accounts do
  @moduledoc """
  Module provides functionality around owner identities.
  """

  import Ecto.Query

  alias Core.Accounts.{Owner, PasswordIdentity, Token}

  def find_owner(%{email: email}) do
    Owner
    |> where([u], u.email == ^email)
    |> DB.replica().one()
    |> case do
      nil -> {:error, :not_found}
      owner -> {:ok, owner}
    end
  end

  def find_owner(%{id: id}) do
    Owner
    |> DB.replica().get(id)
    |> case do
      nil -> {:error, :not_found}
      owner -> {:ok, owner}
    end
  end

  def insert_owner(%{name: name, email: email, password: password}) do
    repo = DB.primary()

    repo.transaction(fn ->
      with {:ok, owner} <- %Owner{} |> Owner.insert(%{name: name, email: email}),
           identity = owner |> Ecto.build_assoc(:password_identity),
           {:ok, password_identity} <- identity |> PasswordIdentity.insert(%{password: password}) do
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
