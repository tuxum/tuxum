defmodule Core.Shops.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field :name, :string
    field :postal_code, :string
    field :country, :string
    field :district, :string
    field :line1, :string
    field :line2, :string
    field :line3, :string
    field :phone, :string

    timestamps()
  end

  def insert_changeset(customer, attrs \\ %{}) do
    customer
    |> cast(attrs, ~w[name postal_code country district line1 line2 line3 phone]a)
    |> validate_required(~w[name postal_code country district line1 phone]a)
    |> validate_length(:country, is: 2)
  end

  def update_changeset(customer, attrs \\ %{}) do
    insert_changeset(customer, attrs)
  end

  def insert(address, attrs) do
    address
    |> insert_changeset(attrs)
    |> DB.primary().insert()
  end

  def update(address, attrs) do
    address
    |> update_changeset(attrs)
    |> DB.primary().update()
  end
end
