defmodule DB.Repo.Migrations.AddCustomerAddressesTable do
  use Ecto.Migration

  def change do
    create table(:customer_addresses) do
      add :customer_id, references(:customers), null: false
      add :address_id, references(:addresses), null: false

      timestamps()
    end

    create unique_index(:customer_addresses, [:customer_id, :address_id])
  end
end
