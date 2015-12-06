# Kwfuns 

[![Build Status](https://travis-ci.org/RobertDober/lab42_defkw.svg)](https://travis-ci.org/RobertDober/lab42_defkw)
[![Hex.pm](https://img.shields.io/hexpm/v/kwfuns.svg?style=flat-square)](https://hex.pm/packages/kwfuns)
[![Inline docs](http://inch-ci.org/github/RobertDober/lab42_defkw.svg)](http://inch-ci.org/github/RobertDober/lab42_defkw)

## Macros to create functions with syntax based keyword parameters with default values

### Usage

```elixir
    defmodule MyModule do
      use Kwfuns
      # Now use the macros defkw or defkwp
      ...
    end
```


Detailed Documentation can be found [here](http://hexdocs.pm/kwfuns/Kwfuns.html)

### LICENSE

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
