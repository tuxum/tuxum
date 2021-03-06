defmodule Core.MixProject do
  use Mix.Project

  def project do
    [
      app: :core,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Core.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:comeonin, "~> 4.1"},
      {:pbkdf2_elixir, "~> 0.12"},
      {:joken, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:decimal, "~> 1.5"},
      {:ex_money, "~> 2.7"},
      {:db, in_umbrella: true},
      {:faker, "~> 0.10", only: :test}
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet -r DB.Repo", "ecto.migrate -r DB.Repo", "test"]
    ]
  end
end
