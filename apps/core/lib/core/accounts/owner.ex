defmodule Core.Accounts.Owner do
  use Core.Schema

  alias Core.Accounts.PasswordIdentity
  alias Core.Shops.Shop

  schema "owners" do
    field :name, :string
    field :email, :string

    has_one :password_identity, PasswordIdentity
    has_one :shop, Shop

    timestamps()
  end

  @email_regex ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$/

  @impl Core.Schema
  def insert_changeset(owner, attrs \\ %{}) do
    owner
    |> cast(attrs, ~w[name email]a)
    |> downcase_email()
    |> validate_required(~w[name email]a)
    |> validate_format(:email, @email_regex)
    |> unique_constraint(:email, name: :owners_email_index)
  end

  @impl Core.Schema
  def update_changeset(owner, attrs \\ %{}) do
    insert_changeset(owner, attrs)
  end

  defp downcase_email(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end

  def insert(owner, attrs) do
    owner
    |> insert_changeset(attrs)
    |> DB.primary().insert()
  end

  def update(owner, attrs) do
    owner
    |> update_changeset(attrs)
    |> DB.primary().update()
  end
end
