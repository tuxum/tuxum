use Mix.Config

config :db, DB.Repo,
  database: "${DB_MASTER_DATABASE}",
  username: "${DB_MASTER_USERNAME}",
  password: "${DB_MASTER_PASSWORD}",
  hostname: "${DB_MASTER_HOSTNAME}"
