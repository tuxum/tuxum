defmodule DB.Repo.Migrations.AddShopsTable do
  use Ecto.Migration

  def change do
    create table(:shops) do
      add :name, :string, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end
  end
end
