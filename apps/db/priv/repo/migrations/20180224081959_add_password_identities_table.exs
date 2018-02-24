defmodule DB.Repo.Migrations.AddPasswordIdentitiesTable do
  use Ecto.Migration

  def change do
    create table(:password_identities) do
      add :digest, :string, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end
  end
end
