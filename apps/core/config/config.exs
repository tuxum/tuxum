use Mix.Config

config :core, :jwt_secret, "LlXP2HLnLS0U/SKFiBeDaNS4p5dIbmieTOA3G/wQubwVDqvjieHF8t8TJocw9Cz0"

config :ecto, json_library: Jason

import_config "#{Mix.env()}.exs"
