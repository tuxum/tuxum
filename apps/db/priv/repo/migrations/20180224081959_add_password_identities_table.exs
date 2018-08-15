defmodule DB.Repo.Migrations.AddPasswordAccountsTable do
  use Ecto.Migration

  def change do
    create table(:password_identities, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :digest, :string, null: false
      add :owner_id, references(:owners, type: :uuid), null: false

      timestamps()
    end
  end
end
