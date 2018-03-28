defmodule DB.Repo.Migrations.AddDeliveryIntervalsTable do
  use Ecto.Migration

  def change do
    create table(:delivery_intervals) do
      add :name, :string, null: false
      add :interval_days, :integer, null: false
    end
  end
end
