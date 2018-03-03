defmodule Core.Identities.PasswordIdentity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Core.Identities.User

  @type t :: %__MODULE__{}

  schema "password_identities" do
    field :digest, :string
    field :password, :string, virtual: true

    belongs_to :user, User

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
end
