# API Controller

Base API controller for Phoenix.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

* Add `api_controller` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:api_controller, "~> 0.1"]
end
```

* Ensure `api_controller`is started before your application:

```elixir
def application do
  [applications: [:api_controller]]
end
```

## Usage

```elixir
defmodule UserController do
  use ApiController

  defmethod :create, user_params do
    # code
  end

  defp user_params do
    [
      name: [required: true, type: :string],
      password: [required: true, type: :string, length: 8..32],
      type: [required: true, type: :string, values: ["user", "admin"]]
      bio: [type: :string],
      age: [type: :integer]
    ]
  end
end
```

if params invalid, response will look like:

```json
{
  "status": "error",
  "reason": "invalid_params",
  "errors": ["name is required",
             "password length must be between 8 and 32 characters",
             "age should be a integer",
             "type should be in [user, admin]"]
}
```

## Configuration
