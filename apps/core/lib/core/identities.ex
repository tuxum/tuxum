defmodule Core.Identities do
  @moduledoc """
  Module provides functionality around user identities.
  """

  import Ecto.Query

  alias Ecto.Multi
  alias Core.Identities.{User, PasswordIdentity, Token}

  @callback find_user(map()) :: %User{}
  @callback insert_user(map()) ::
    {:ok, %{user: %User{}, password_identity: %PasswordIdentity{}}} |
    {:error, atom(), Ecto.Changeset.t(), map()}
  @callback authenticate(String.t(), String.t()) :: %User{} | nil
  @callback correct_password?(%User{}, String.t()) :: boolean()
  @callback user_from_token(String.t()) :: {:ok, %User{}} | :error
  @callback token_from_user(%User{}) :: {:ok, String.t()}

  def find_user(%{email: email}) do
    User
    |> where([u], u.email == ^email)
    |> DB.replica().one()
  end

  def find_user(%{id: id}) do
    User |> DB.replica().get(id)
  end

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
      error ->
        error
    end
  end

  def authenticate(email, password) do
    with user when user != nil <- find_user(%{email: email}),
         true <- correct_password?(user, password) do
      user
    else
      _ -> nil
    end
  end

  def correct_password?(user, password) do
    repo = DB.replica()

    case repo.preload(user, :password_identity) do
      %User{password_identity: identity = %PasswordIdentity{}} ->
        Comeonin.Pbkdf2.checkpw(password, identity.digest)
      _ ->
        false
    end
  end

  def user_from_token(token) do
    case Token.to_user(token) do
      nil -> :error
      user -> {:ok, user}
    end
  end

  def token_from_user(user) do
    {:ok, Token.from_user(user)}
  end
end
