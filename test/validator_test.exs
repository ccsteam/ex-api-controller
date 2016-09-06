defmodule ApiController.ValidatorTest do
  use ExUnit.Case, async: false
  alias ApiController.Validator

  test "extract_schema_keys! method returns list of keys" do
    schema_keys = Validator.extract_schema_keys!(schema)
    assert schema_keys == ["name", "surname"]
  end

  test "filter_attributes! method filter request_params" do
    schema_keys = Validator.extract_schema_keys!(schema)
    attributes = Validator.filter_attributes!(valid_request_params, schema_keys)
    assert attributes == %{"name" => "John", "surname" => "O'connor"}
  end

  test "validate_attributes! method returns errors if errors list not empty" do
    res = Validator.validate_attributes(invalid_request_params, schema)
    assert res == {:error, ["name is required and can't be blank",
                            "surname is required and can't be blank"]}
  end

  test "validate_attributes! method returns ok if errors list is empty" do
    res = Validator.validate_attributes(valid_request_params, schema)
    assert res == {:ok, :valid}
  end

  test "validate_attribute! method returns list of validation results" do
    valid = Validator.validate_attribute!({:name, [required: true]}, "value")
    invalid = Validator.validate_attribute!({:name, [required: true]}, "")
    assert valid == [nil]
    assert invalid == ["name is required and can't be blank"]
  end

  test "validate! required returns nil if list not empty" do
    res = Validator.validate!({:required, true}, {:field, ["value"]})
    assert is_nil(res)
  end

  test "validate! required returns error if list is empty" do
    res = Validator.validate!({:required, true}, {:field, []})
    assert res == "field is required and can't be blank"
  end

  test "validate! required returns nil if string not blank" do
    res = Validator.validate!({:required, true}, {:field, "value"})
    assert is_nil(res)
  end

  test "validate! required returns error if string is blank" do
    res = Validator.validate!({:required, true}, {:field, ""})
    assert res == "field is required and can't be blank"
  end

  test "validate! inclusion returns nil if value in list" do
    res = Validator.validate!({:inclusion, ["value"]}, {:field, "value"})
    assert is_nil(res)
  end

  test "validate! inclusion returns error if value not in list" do
    res = Validator.validate!({:inclusion, ["foo"]}, {:field, "value"})
    assert res == "field should be in [\"foo\"]"
  end

  test "validate! exclusion returns nil if value not in list" do
    res = Validator.validate!({:exclusion, ["foo"]}, {:field, "value"})
    assert is_nil(res)
  end

  test "validate! exclusion returns error if value in list" do
    res = Validator.validate!({:exclusion, ["foo"]}, {:field, "foo"})
    assert res == "field should not be in [\"foo\"]"
  end

  test "validate! type returns nil if value is nil" do
    res = Validator.validate!({:type, :string}, {:field, nil})
    assert is_nil(res)
  end

  test "validate! string type returns nil if value is binary" do
    res = Validator.validate!({:type, :string}, {:field, "value"})
    assert is_nil(res)
  end

  test "validate! string type returns error if value isn't binary" do
    res = Validator.validate!({:type, :string}, {:field, 2})
    assert res == "field should be a string"
  end

  test "validate! integer type returns nil if value is integer" do
    res = Validator.validate!({:type, :integer}, {:field, 2})
    assert is_nil(res)
  end

  test "validate! integer type returns error if value isn't integer" do
    res = Validator.validate!({:type, :integer}, {:field, ""})
    assert res == "field should be a integer"
  end

  test "validate! map type returns nil if value is map" do
    res = Validator.validate!({:type, :map}, {:field, %{}})
    assert is_nil(res)
  end

  test "validate! map type returns error if value isn't map" do
    res = Validator.validate!({:type, :map}, {:field, ""})
    assert res == "field should be a map"
  end

  test "validate! list type returns nil if value is list" do
    res = Validator.validate!({:type, :list}, {:field, [123]})
    assert is_nil(res)
  end

  test "validate! list type returns error if value isn't list" do
    res = Validator.validate!({:type, :list}, {:field, ""})
    assert res == "field should be a list"
  end

  test "validate! length range returns error if value length not in range" do
    res = Validator.validate!({:length, 10..20}, {:field, "foo"})
    assert res == "field length should be between 10 and 20 characters"
  end

  test "validate! length returns error if value length greater than length" do
    res = Validator.validate!({:length, 5}, {:field, "foobar"})
    assert res == "field length should be less than or equal 5 characters"
  end

  test "validate! length returns nil if value length in range" do
    res = Validator.validate!({:length, 5..20}, {:field, "foobar"})
    assert is_nil(res)
  end

  test "validate! length returns nil if value length less than or equal length" do
    res = Validator.validate!({:length, 10}, {:field, "foobar"})
    assert is_nil(res)
  end

  test "validation_result! returns errors if errors list not empty" do
    res = Validator.validation_result(["field is required and can't be blank"])
    assert res == {:error, ["field is required and can't be blank"]}
  end

  test "validation_result! returns ok if errors list is empty" do
    res = Validator.validation_result([])
    assert res == {:ok, :valid}
  end

  defp valid_request_params do
    %{"name" => "John", "surname" => "O'connor", "foo" => "bar"}
  end
  defp invalid_request_params do
    %{"name" => "", "surname" => ""}
  end

  defp schema do
    [name: [required: true],
     surname: [required: true]]
  end
end
