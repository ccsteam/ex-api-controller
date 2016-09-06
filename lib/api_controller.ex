defmodule ApiController do
  alias ApiController.{Utils, View}
  @doc """
  Render JSON error and status.

  Response example:
  {"status": "error", "reason": "record_not_found", errors: []}
  """
  @callback show_error(Plug.Conn.t, String.t, atom | non_neg_integer, [] | [String.t]) :: Plug.Conn.t

  @doc """
  Render JSON result and status.

  Response example:
  {"status": "ok", "result": "data"}
  """
  @callback show_result(Plug.Conn.t, term, atom | non_neg_integer) :: Plug.Conn.t

  defmacro __using__(_) do
    quote do
      use unquote(Utils.application_module).Web, :controller

      import unquote(__MODULE__)
      @behaviour unquote(__MODULE__)

      def show_error(conn, reason, status \\ :bad_request, errors \\ []) do
        conn
        |> put_view(View)
        |> put_status(status)
        |> render("error.json", reason: reason, errors: errors)
      end

      def show_result(conn, result, status \\ 200) do
        conn
        |> put_view(View)
        |> put_status(status)
        |> render("result.json", result: result)
      end

      defoverridable show_error: 4, show_result: 3
    end
  end

  @doc """
  Defines a controller method with the given name

  ## Examples

      defmethod :create, user_schema do
        name = request_params["name"]
        show_result(conn, name)
      end

      defp user_schema do
        [
          name: [required: true, type: :string],
          password: [required: true, type: :string, length: 8..32],
          type: [required: true, type: :string, inclusion: ["user", "admin"]]
          bio: [type: :string],
          age: [type: :integer]
        ]
      end
  """
  defmacro defmethod(name, schema, do: block) do
    quote do
      def unquote(name)(var!(conn), var!(request_params)) do
        case ApiController.Validator.validate_attributes(var!(request_params), unquote(schema)) do
          {:error, errors} ->
            show_error(var!(conn), "invalid_attributes", :bad_request, errors)
          _ ->
            unquote(block)
        end
      end
    end
  end

end
