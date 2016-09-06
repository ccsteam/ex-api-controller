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

Set your application module in config:

```elixir
config :api_controller,
  application_module: MyApp
```

```elixir
defmodule UserController do
  use ApiController

  defmethod :create, user_params do
    # name = request_params["name"]
    # show_result(conn, name)
  end

  defp user_params do
    [
      name: [required: true, type: :string],
      password: [required: true, type: :string, length: 8..32],
      type: [required: true, type: :string, inclusion: ["user", "admin"]],
      bio: [type: :string],
      age: [type: :integer],
      country: [type: :string, exclusion: ["Russia"]],
      friends: [type: :list, length: 10]
    ]
  end
end
```

if params invalid, response will look like:

```json
{
  "status": "error",
  "reason": "invalid_params",
  "errors": ["name is required and can't be blank",
             "password length must be between 8 and 32",
             "age should be a integer",
             "type should be in [\"user\", \"admin\"]",
             "country should not be in [\"Russia\"]",
             "friends length should be less than or equal 10"]
}
```

## Configuration

```elixir
config :api_controller,
  application_module: MyApp
```
