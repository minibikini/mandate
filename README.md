[![Mandate CI Status](https://github.com/minibikini/mandate/actions/workflows/elixir.yml/badge.svg)](https://github.com/minibikini/mandate/actions/workflows/elixir.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/mandate.svg?maxAge=2592000)](https://hex.pm/packages/mandate)
[![Hex.pm](https://img.shields.io/hexpm/l/mandate.svg?maxAge=2592000)](https://hex.pm/packages/mandate)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs-purple)](https://hexdocs.pm/mandate)

# Mandate

A declarative framework for building robust, elegant command-line interfaces (CLIs) in Elixir with minimal boilerplate.

## Key Features

- **Declarative Approach:** Mandate allows you to _declare_ the structure of your CLI using a simple DSL, rather than writing imperative code to parse arguments manually.
- **Minimal Boilerplate:** Mandate handles argument parsing, validation, type conversion, and help text generation so you can focus on the core logic of your tasks.
- **Mix and Igniter compatibility:** Mandate tasks can be defined as `use Mandate, as: :mix_task` or `use Mandate, as: :igniter_task` for seamless integration with existing systems.
- **Extensible:** Built on top of Spark, a framework for creating DSLs, making it easy to extend and customize for your specific needs.
- **Comprehensive Help:** Automatically generates help text and usage information based on your task definit  ions.
- **Type Validation:** Built-in support for common data types and validation rules.

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
