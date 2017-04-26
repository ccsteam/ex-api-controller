defmodule ApiController.View do
  alias ApiController.Utils

  defmacro __before_compile__(_env) do
    quote do
      use unquote(Utils.application_module).Web, :view
    end
  end

  def render("result.json", %{result: result}) do
    %{status: "ok", result: result}
  end
  def render("error.json", %{reason: reason, errors: errors, error_data: error_data}) do
    %{status: "error", reason: reason, errors: errors, error_data: error_data}
  end
end
