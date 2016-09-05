defmodule ApiController.View do
  alias ApiController.Utils

  quote do
    use unquote(Utils.application_module).Web, :view
  end

  def render("error.json", %{error: error}) do
    %{status: "error", reason: error}
  end
end
