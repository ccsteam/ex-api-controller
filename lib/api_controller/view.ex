defmodule ApiController.View do
  alias ApiController.Utils

  defmacro __before_compile__(_env) do
    quote do
      use Utils.application_module.Web, :view
    end
  end

  def render("error.json", %{error: error}) do
    %{status: "error", reason: error}
  end
end
