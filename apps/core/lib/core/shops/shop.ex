defmodule Core.Shops.Shop do
  use Ecto.Schema
  import Ecto.Changeset

  alias Core.Identities.User

  schema "shops" do
    field :name, :string

    belongs_to :user, User

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, ~w[name]a)
    |> validate_required(~w[name]a)
    |> unique_constraint(:user_id, name: :shops_user_id_index)
  end
end
