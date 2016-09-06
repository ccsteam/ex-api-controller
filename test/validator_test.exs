defmodule ApiController.ValidatorTest do
  use ExUnit.Case, async: false
  alias ApiController.Validator

  test "extract_schema_keys! method returns list of keys" do
    schema_keys = Validator.extract_schema_keys!(schema)
    assert schema_keys == ["name", "surname"]
  end

  test "filter_attributes! method filter request_params" do
    schema_keys = Validator.extract_schema_keys!(schema)
    attributes = Validator.filter_attributes!(request_params, schema_keys)
    assert attributes == %{"name" => "John", "surname" => "O'connor"}
  end

  defp request_params do
    %{"name" => "John", "surname" => "O'connor", "foo" => "bar"}
  end

  defp schema do
    [name: [required: true],
     surname: [required: true]]
  end
end
