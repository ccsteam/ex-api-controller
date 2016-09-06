defmodule ApiController.Model do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: [schema: 1, field: 3]

      def new(params) do
        attributes = params
                     |> Map.take(Keyword.keys(@struct_fields))
        struct = %__MODULE__{}
      end
    end
  end

  defmacro schema(block) do
    quote do
      Module.register_attribute(__MODULE__, :struct_fields, accumulate: true)
      Module.register_attribute(__MODULE__, :model_fields, accumulate: true)

      unquote(block)

      Module.eval_quoted __ENV__, [
        ApiController.Model.__defstruct__(@struct_fields)
      ]
    end
  end

  defmacro field(name, type \\ :string, opts \\ []) do
    quote do
      ApiController.Model.__field__(__MODULE__, unquote(name), unquote(type), unquote(opts))
    end
  end

  @doc false
  def __field__(mod, name, type, opts) do
    put_model_field(mod, name, type)
    put_struct_field(mod, name, default_value(opts))
  end

  @doc false
  def __defstruct__(struct_fields) do
    quote do
      defstruct unquote(Macro.escape(struct_fields))
    end
  end

  defp put_model_field(mod, name, type) do
    Module.put_attribute(mod, :model_fields, {name, type})
  end
  defp put_struct_field(mod, name, value) do
    fields = Module.get_attribute(mod, :struct_fields)

    if List.keyfind(fields, name, 0) do
      raise ArgumentError, "field #{inspect name} is already set on schema"
    end
    Module.put_attribute(mod, :struct_fields, {name, value})
  end
  defp default_value(opts) do
    Keyword.get(opts, :default)
  end
end
