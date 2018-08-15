defmodule DB.Repo.Migrations.AddDeliveryIntervalsTable do
  use Ecto.Migration

  def change do
    create table(:delivery_intervals, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :interval_days, :integer, null: false
    end
  end
end
