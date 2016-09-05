defmodule ApiController do
  alias ApiController.{Utils, View}
  @doc """
  Render JSON error and status
  """
  @callback show_error(Plug.Conn.t, String.t, atom | non_neg_integer) :: Plug.Conn.t

  @doc """
  Render JSON result and status
  """
  @callback show_result(Plug.Conn.t, term, atom | non_neg_integer) :: Plug.Conn.t

  defmacro __using__(_) do
    quote do
      use unquote(Utils.application_module).Web, :controller

      @behaviour unquote(__MODULE__)

      def show_error(conn, error, status \\ :bad_request) do
        conn
        |> put_view(View)
        |> put_status(status)
        |> render("error.json", error: error)
      end

      def show_result(conn, result, status \\ 200) do
        conn
        |> put_view(View)
        |> put_status(status)
        |> render("result.json", result: result)
      end

      defmacro presence?(attribute) do
        case Macro.Env.in_guard?(__CALLER__) do
          true ->
            quote do
              not is_nil(unquote(attribute)) and unquote(attribute) != ""
            end
          false ->
            quote do
              attribute = unquote(attribute)
              !is_nil(attribute) && attribute != ""
            end
        end
      end

      defoverridable show_error: 3, show_result: 3
    end
  end
end
