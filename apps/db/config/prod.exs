use Mix.Config

config :db, DB.Repo,
  database: {:system, "DB_MASTER_DATABASE", "tuxum"},
  username: {:system, "DB_MASTER_USERNAME", "postgres"},
  password: {:system, "DB_MASTER_PASSWORD", "postgres"},
  hostname: {:system, "DB_MASTER_HOSTNAME", "localhost"}
