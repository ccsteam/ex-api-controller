defmodule ApiController.Validator do

  @spec validate_attributes(map, Keyword.t) :: {:ok, :valid} | {:error, [String.t]}
  def validate_attributes(request_params, schema)
      when is_map(request_params) do
    schema_keys = extract_schema_keys!(schema)
    request_params = request_params |> filter_attributes!(schema_keys)

    schema
    |> Enum.map(fn {name, validations} ->
        value = Map.get(request_params, Atom.to_string(name), nil)
        validate_attribute!({name, validations}, value)
      end)
    |> List.flatten
    |> Enum.reject(&is_nil/1)
    |> validation_result
  end

  @doc false
  @spec validate_attribute!({atom, Keyword.t}, term) :: [] | [String.t]
  def validate_attribute!({name, validations}, value) do
    validations
    |> Enum.map(&validate!(&1, {name, value}))
  end

  @doc false
  @spec filter_attributes!(map, [String.t]) :: map
  def filter_attributes!(request_params, schema_keys)
      when is_map(request_params) and is_list(schema_keys) do
    request_params
    |> Map.take(schema_keys)
  end

  @doc false
  @spec extract_schema_keys!(Keyword.t) :: [String.t]
  def extract_schema_keys!(schema) do
    schema
    |> Keyword.keys
    |> Enum.map(&Atom.to_string/1)
  end

  @doc false
  @spec validation_result([] | [String.t]) :: {:ok, :valid} | {:error, [String.t]}
  def validation_result([]) do
    {:ok, :valid}
  end
  def validation_result(errors) do
    {:error, errors}
  end

  @doc false
  @spec validate!({atom, term}, {atom, term}) :: String.t | nil
  def validate!({:required, true}, {attribute, nil}) do
    validate_error!(:required, attribute)
  end
  def validate!({:required, true}, {attribute, value})
      when is_list(value) do
    if value == [], do: validate_error!(:required, attribute)
  end
  def validate!({:required, true}, {attribute, value})
      when is_binary(value) do
    if value == "", do: validate_error!(:required, attribute)
  end
  def validate!({:type, :string}, {_attribute, value})
      when is_binary(value) do
    nil
  end
  def validate!({:type, :string}, {attribute, _value}) do
    validate_error!({:type, :string}, attribute)
  end
  def validate!({:type, :integer}, {_attribute, value})
      when is_integer(value) do
    nil
  end
  def validate!({:type, :integer}, {attribute, _value}) do
    validate_error!({:type, :integer}, attribute)
  end
  def validate!({:type, :map}, {_attribute, value})
      when is_map(value) do
    nil
  end
  def validate!({:type, :map}, {attribute, _value}) do
    validate_error!({:type, :map}, attribute)
  end
  def validate!(_condition, _attribute) do
    nil
  end

  defp validate_error!(:required, attribute) do
    "#{attribute} is required and can't be blank"
  end
  defp validate_error!({:type, type}, attribute) do
    "#{attribute} should be a #{type}"
  end
end
