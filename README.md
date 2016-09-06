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
defmodule MyApp.UserController do
  use ApiController

  # Inside method you can access 'request_params' and 'conn' variables
  defmethod :create, user_schema do
    # name = request_params["name"]
    # show_result(conn, name)
  end

  defp user_schema do
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
  "reason": "invalid_attributes",
  "errors": ["name is required and can't be blank",
             "password length must be between 8 and 32",
             "age should be a integer",
             "type should be in [\"user\", \"admin\"]",
             "country should not be in [\"Russia\"]",
             "friends length should be less than or equal 10"]
}
```

You also can use API helpers:

```elixir
@doc """
Render JSON error and status.

Response example:
{"status": "error", "reason": "record_not_found", errors: []}
"""
@show_error(Plug.Conn.t, String.t, atom | non_neg_integer) :: Plug.Conn.t
def show_error(conn, reason, status \\ :bad_request, errors \\ [])
```

```elixir
@doc """
Render JSON result and status.

Response example:
{"status": "ok", "result": "data"}
"""
@callback show_result(Plug.Conn.t, term, atom | non_neg_integer) :: Plug.Conn.t
def show_result(conn, result, status \\ 200)
```

## Configuration

```elixir
config :api_controller,
  application_module: MyApp
```
