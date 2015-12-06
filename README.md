# Kwfuns 

[![Build Status](https://travis-ci.org/RobertDober/lab42_defkw.svg)](https://travis-ci.org/RobertDober/lab42_defkw)
[![Hex.pm](https://img.shields.io/hexpm/v/kwfuns.svg?style=flat-square)](https://hex.pm/packages/kwfuns)

## Macros to create functions with syntax based keyword parameters with default values


###  `defkw`

Defines a function with defaulted keyword parameters that are syntactically
available in the same way as positional parameters.

```elixir
defkw multiply_sum( factor, lhs: 0, rhs: 1 ) do
  factor * ( lhs + rhs )
end
```

would compile to the following code

```elixir
def multiply_sum( factor, keywords // [] ) do
  %{lhs: lhs, rhs: rhs} =
    Keyword.merge( [lhs: 0, rhs: 0], keywords ) 
    |> Enum.into( %{} )
  factor * ( lhs + rhs )
end
```

### `defkwp`

Same as `defkw` above but defining a private function.

## LICENSE

Same as Elixir, which is Apache 2.0, please refer to [LICENSE](LICENSE) for details.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add kwfuns to your list of dependencies in `mix.exs`:

        def deps do
          [{:kwfuns, "~> 0.0.1"}]
        end

  2. Ensure kwfuns is started before your application:

        def application do
          [applications: [:kwfuns]]
        end
