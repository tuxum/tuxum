use Mix.Config

config :db, DB.Repo,
  database: "tuxum_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
