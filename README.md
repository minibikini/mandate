[![Mandate CI Status](https://github.com/minibikini/mandate/actions/workflows/elixir.yml/badge.svg)](https://github.com/minibikini/mandate/actions/workflows/elixir.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/mandate.svg?maxAge=2592000)](https://hex.pm/packages/mandate)
[![Hex.pm](https://img.shields.io/hexpm/l/mandate.svg?maxAge=2592000)](https://hex.pm/packages/mandate)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs-purple)](https://hexdocs.pm/mandate)

# Mandate

Build robust, elegant CLIs with minimal boilerplate.

## Key Features

- **Declarative Approach:** Mandate allows you to _declare_ the structure of your CLI using a simple DSL, rather than writing imperative code to parse arguments manually.
- **Minimal Boilerplate:** Mandate handles the tedious aspects of CLI development, so you can focus on the core logic of your tasks.
- **Mix and Igniter compatibility:** Mandate tasks can be defined as `use Mandate, as: :mix_task` or `use Mandate, as: :igniter_task`.
- **Extensible:** Mandate is built on top of Spark, a framework for creating DSLs, which makes it easy to extend and customize.

## Installation

The package can be installed by adding `mandate` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mandate, "~> 0.30"}
  ]
end
```

## License

MIT License

Copyright (c) 2025 Egor Kislitsyn
