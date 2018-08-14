defmodule Tuxum.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate",  "run apps/db/priv/repo/seeds.exs"],
      test: ["ecto.create --quiet", "ecto.migrate", "run apps/db/priv/repo/seeds.exs", "test"]
    ]
  end
end
