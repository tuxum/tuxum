if Mix.env() == :test do
  defmodule Core.Fixtures do
    @moduledoc """
    Collection of functions for generating test fixtures.
    Available only :test environment
    """

    def owner(attrs \\ %{}) do
      %{
        name: Faker.Name.name(),
        email: Faker.Internet.email(),
        password: Faker.Util.format("%10a")
      }
      |> merge(attrs)
    end

    def shop(attrs \\ %{}) do
      %{
        name: Faker.Company.name()
      }
      |> merge(attrs)
    end

    def onetime_product(attrs \\ %{}) do
      %{
        name: Faker.Commerce.product_name(),
        is_public: true,
        price: %{currency: "USD", amount: "100"},
        shipping_fee: %{currency: "USD", amount: "5"}
      }
      |> merge(attrs)
    end

    def subscription_product(attrs \\ %{}) do
      %{
        name: Faker.Commerce.product_name(),
        is_public: true,
        price: %{currency: "USD", amount: "100"},
        setup_fee: %{currency: "USD", amount: "10"},
        shipping_fee: %{currency: "USD", amount: "5"},
        delivery_interval_id: nil
      }
      |> merge(attrs)
    end

    def customer(attrs \\ %{}) do
      %{
        name: Faker.Name.name(),
        email: Faker.Internet.email(),
        addresses: [address()]
      }
      |> merge(attrs)
    end

    def address(attrs \\ %{}) do
      %{
        label: "Home",
        name: Faker.Name.name(),
        postal_code: Faker.Address.zip_code(),
        country: Faker.Address.country_code(),
        district: Faker.Address.state(),
        line1: Faker.Address.street_address(),
        line2: Faker.Address.secondary_address(),
        line3: nil,
        phone: Faker.Phone.EnUs.phone()
      }
      |> merge(attrs)
    end

    defp merge(base, attrs) when is_map(attrs) do
      Map.merge(base, attrs)
    end

    defp merge(base, attrs) do
      Map.merge(base, Enum.into(attrs, %{}))
    end
  end
end
