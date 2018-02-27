if Mix.env() == :test do
  defmodule Core.Fixtures do
    @moduledoc """
    Collection of functions for generating test fixtures.
    Available only :test environment
    """

    def user do
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
  end
end
