defmodule Core.Shops.Shop do
  use Ecto.Schema
  import Ecto.Changeset

  alias Core.Identities.Owner
  alias Core.Shops.OnetimeProduct

  @type t :: %__MODULE__{}

  schema "shops" do
    field :name, :string

    belongs_to :owner, Owner

    has_many :onetime_products, OnetimeProduct

    timestamps()
  end

  def changeset(owner, attrs \\ %{}) do
    owner
    |> cast(attrs, ~w[name]a)
    |> validate_required(~w[name]a)
    |> unique_constraint(:owner_id, name: :shops_owner_id_index)
  end
end
