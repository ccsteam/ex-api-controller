defmodule ApiController.TestController do
  use ApiController

  defmethod :create do
    params["key"]
  end
end
