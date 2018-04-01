defmodule DB.Repo.Migrations.AddCustomersTable do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :shop_id, references(:shops), null: false

      timestamps()
    end
  end
end
