defmodule Core.Identities do
  @moduledoc """
  Module provides functionality around user identities.
  """

  import Ecto.Query, only: [from: 2]

  alias Ecto.Multi
  alias Core.Identities.{User, PasswordIdentity}

  def find_user(%{email: email}) do
    repo = DB.replica()

    from(u in User, where: u.email == ^email) |> repo.one
  end

  def find_user(%{id: id}) do
    repo = DB.replica()

    from(u in User, where: u.id == ^id) |> repo.one
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
      |> repo.insert
    end)
    |> repo.transaction
  end
end
