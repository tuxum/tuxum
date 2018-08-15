defmodule DB.Repo.Migrations.AddOwnersTable do
  use Ecto.Migration

  def change do
    create table(:owners, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :email, :string, null: false

      timestamps()
    end

    create unique_index(:owners, [:email], name: :owners_email_index)
  end
end
