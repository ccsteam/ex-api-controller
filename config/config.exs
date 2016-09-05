use Mix.Config

config :api_controller,
  application_module: ApiController

import_config "#{Mix.env}.exs"
