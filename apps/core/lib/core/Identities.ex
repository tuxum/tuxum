defmodule Core.Identities do
  @moduledoc """
  Module provides functionality around user identities.
  """

  alias Ecto.Multi
  alias Core.Identities.{User, PasswordIdentity}

  def insert_user(%{name: name, email: email, password: password}) do
    repo = DB.primary()
    user_changeset = %User{} |> User.changeset(%{name: name, email: email})

    Multi.new()
    |> Multi.insert(:user, user_changeset)
    |> Multi.run(:password_identity, fn %{user: user} ->
      user
      |> Ecto.build_assoc(:password_identity)
      |> PasswordIdentity.changeset(%{password: password})
      |> repo.insert
    end)
    |> repo.transaction
  end
end
