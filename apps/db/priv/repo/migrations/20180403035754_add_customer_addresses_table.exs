defmodule DB.Repo.Migrations.AddCustomerAddressesTable do
  use Ecto.Migration

  def change do
    create table(:customer_addresses, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :customer_id, references(:customers, type: :uuid), null: false
      add :address_id, references(:addresses, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:customer_addresses, [:customer_id, :address_id])
  end
end
