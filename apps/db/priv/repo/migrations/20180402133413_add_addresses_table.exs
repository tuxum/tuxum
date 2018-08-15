defmodule DB.Repo.Migrations.AddAddressesTable do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :label, :string
      add :name, :string, null: false
      add :postal_code, :string, null: false
      add :country, :string, null: false, size: 2
      add :district, :string, null: false
      add :line1, :string, null: false
      add :line2, :string
      add :line3, :string
      add :phone, :string, null: false

      timestamps()
    end

    create index(:addresses, [:country])
  end
end
