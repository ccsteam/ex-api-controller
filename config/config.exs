use Mix.Config

config :api_controller,
  application_module: ApiController,
  attributes_key_path: false

import_config "#{Mix.env}.exs"
