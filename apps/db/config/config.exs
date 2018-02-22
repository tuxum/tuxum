use Mix.Config

config :db, ecto_repos: [DB.Repo]

config :db, DB.Repo,
  adapter: Ecto.Adapters.Postgres

import_config "#{Mix.env()}.exs"
