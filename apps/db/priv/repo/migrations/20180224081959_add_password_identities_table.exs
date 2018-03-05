defmodule DB.Repo.Migrations.AddPasswordAccountsTable do
  use Ecto.Migration

  def change do
    create table(:password_identities) do
      add :digest, :string, null: false
      add :owner_id, references(:owners), null: false

      timestamps()
    end
  end
end
