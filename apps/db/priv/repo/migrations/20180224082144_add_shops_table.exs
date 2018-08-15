defmodule DB.Repo.Migrations.AddShopsTable do
  use Ecto.Migration

  def change do
    create table(:shops, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :owner_id, references(:owners, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:shops, [:owner_id], name: :shops_owner_id_index)
  end
end
