if Mix.env() == :test do
  defmodule Core.Fixtures do
    @moduledoc """
    Collection of functions for generating test fixtures.
    Available only :test environment
    """

    def owner do
      %{
        name: Faker.Name.name(),
        email: Faker.Internet.email(),
        password: Faker.Util.format("%10a")
      }
    end

    def shop do
      %{
        name: Faker.Company.name()
      }
    end

    def onetime_product do
      %{
        name: Faker.Commerce.product_name(),
        is_public: true,
        price: %{currency: "USD", amount: "100"},
        shipping_fee: %{currency: "USD", amount: "5"}
      }
    end

    def subscription_product do
      %{
        name: Faker.Commerce.product_name(),
        is_public: true,
        price: %{currency: "USD", amount: "100"},
        setup_fee: %{currency: "USD", amount: "10"},
        shipping_fee: %{currency: "USD", amount: "5"},
        delivery_interval_id: 1
      }
    end

    def customer do
      %{
        name: Faker.Name.name(),
        email: Faker.Internet.email()
      }
    end

    def address do
      %{
        name: Faker.Name.name(),
        postal_code: Faker.Address.zip_code(),
        country: Faker.Address.country_code(),
        district: Faker.Address.state(),
        line1: Faker.Address.street_address(),
        line2: Faker.Address.secondary_address(),
        line3: nil,
        phone: Faker.Phone.EnUs.phone(),
      }
    end
  end
end
