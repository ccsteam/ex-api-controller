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
