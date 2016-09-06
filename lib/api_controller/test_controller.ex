defmodule TestController do
  use ApiController

  defmethod :create, test_schema do
    request_params["name"]
  end

  defp test_schema do
    [
      name: [required: true],
      surname: [required: true]
    ]
  end
end
