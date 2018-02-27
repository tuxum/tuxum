defmodule DB.Repo.Migrations.AddShopsTable do
  use Ecto.Migration

  def change do
    create table(:shops) do
      add :name, :string, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create unique_index(:shops, [:user_id], name: :shops_user_id_index)
  end
end
