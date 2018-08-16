defmodule DB.Repo.Migrations.AddIntervalsTable do
  use Ecto.Migration

  def change do
    create table(:intervals, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :unit, :string, null: false
      add :count, :integer, null: false
    end
  end
end
