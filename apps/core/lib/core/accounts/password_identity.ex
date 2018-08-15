defmodule Core.Accounts.PasswordIdentity do
  use Core.Schema

  alias Core.Accounts.Owner

  schema "password_identities" do
    field :digest, :string
    field :password, :string, virtual: true

    belongs_to :owner, Owner

    timestamps()
  end

  def changeset(password_identity, attrs \\ %{}) do
    password_identity
    |> cast(attrs, ~w[digest password]a)
    |> validate_length(:password, min: 10)
    |> hash_password()
    |> validate_required(~w[digest]a)
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        changeset |> put_change(:digest, Comeonin.Pbkdf2.hashpwsalt(password))
    end
  end

  def insert(identity, attrs) do
    identity
    |> changeset(attrs)
    |> DB.primary().insert()
  end

  def update(identity, attrs) do
    identity
    |> changeset(attrs)
    |> DB.primary().update()
  end
end
