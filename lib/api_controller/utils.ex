defmodule ApiController.Utils do

  def application_module do
    Application.get_env(:api_controller, :application_module)
  end
end
