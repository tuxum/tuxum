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
  end
end