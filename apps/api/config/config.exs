# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  namespace: API

# Configures the endpoint
config :api, APIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wITyJIM0QK1aajRZDE9GndVA+mYdfqf4MUDqKJF3aF0QWQ4K8t2epVIUB08s2vbv",
  render_errors: [view: APIWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: API.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
