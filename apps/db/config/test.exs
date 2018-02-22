use Mix.Config

config :db, DB.Repo,
  database: "tuxum_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
