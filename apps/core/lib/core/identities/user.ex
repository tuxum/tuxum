defmodule Core.Identities.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Core.Identities.PasswordIdentity
  alias Core.Shops.Shop

  schema "users" do
    field :name, :string
    field :email, :string

    has_one :password_identity, PasswordIdentity
    has_many :shops, Shop

    timestamps()
  end

  @email_regex ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$/

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, ~w[name email]a)
    |> downcase_email()
    |> validate_required(~w[name email]a)
    |> validate_format(:email, @email_regex)
    |> unique_constraint(:email, name: :users_email_index)
  end

  defp downcase_email(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end
end
