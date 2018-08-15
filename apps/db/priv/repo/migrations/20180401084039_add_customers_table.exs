defmodule DB.Repo.Migrations.AddCustomersTable do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :email, :string, null: false
      add :shop_id, references(:shops, type: :uuid), null: false

      timestamps()
    end

    create index(:customers, [:email])
    create unique_index(:customers, [:shop_id, :email], name: :customers_shop_id_email_index)
  end
end
