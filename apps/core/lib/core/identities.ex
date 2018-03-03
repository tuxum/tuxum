defmodule Core.Identities do
  @moduledoc """
  Module provides functionality around user identities.
  """

  import Ecto.Query

  alias Ecto.Multi
  alias Core.Identities.{User, PasswordIdentity, Token}

  @spec find_user(map()) :: {:ok, User.t()} | {:error, :not_found}
  def find_user(%{email: email}) do
    User
    |> where([u], u.email == ^email)
    |> DB.replica().one()
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def find_user(%{id: id}) do
    User
    |> DB.replica().get(id)
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  @spec insert_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def insert_user(%{name: name, email: email, password: password}) do
    repo = DB.primary()
    user_changeset = %User{} |> User.changeset(%{name: name, email: email})

    Multi.new()
    |> Multi.insert(:user, user_changeset)
    |> Multi.run(:password_identity, fn %{user: user} ->
      user
      |> Ecto.build_assoc(:password_identity)
      |> PasswordIdentity.changeset(%{password: password})
      |> repo.insert()
    end)
    |> repo.transaction()
    |> case do
      {:ok, %{user: user, password_identity: password_identity}} ->
        {:ok, %User{user | password_identity: password_identity}}
      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  @spec authenticate(String.t(), String.t()) :: {:ok, User.t()} | :error
  def authenticate(email, password) do
    with {:ok, user} <- find_user(%{email: email}),
         true <- correct_password?(user, password) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  @spec correct_password?(User.t(), String.t()) :: boolean()
  def correct_password?(user, password) do
    repo = DB.replica()

    case repo.preload(user, :password_identity) do
      %User{password_identity: identity = %PasswordIdentity{}} ->
        Comeonin.Pbkdf2.checkpw(password, identity.digest)
      _ ->
        false
    end
  end

  @spec user_from_token(Token.t()) :: {:ok, User.t()} | :error
  def user_from_token(token) do
    case Token.to_user(token) do
      nil -> :error
      user -> {:ok, user}
    end
  end

  @spec token_from_user(User.t()) :: {:ok, Token.t()}
  def token_from_user(user) do
    {:ok, Token.from_user(user)}
  end
end
