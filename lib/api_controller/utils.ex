defmodule ApiController.Utils do

  @spec application_module :: module
  def application_module do
    Application.get_env(:api_controller, :application_module)
  end

  @spec attributes_key_path :: false | String.t | [String.t]
  def attributes_key_path do
    Application.get_env(:api_controller, :attributes_key_path) || false
  end
end
