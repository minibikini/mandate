[![Mandate CI Status](https://github.com/minibikini/mandate/actions/workflows/elixir.yml/badge.svg)](https://github.com/minibikini/mandate/actions/workflows/elixir.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/mandate.svg?maxAge=2592000)](https://hex.pm/packages/mandate)
[![Hex.pm](https://img.shields.io/hexpm/l/mandate.svg?maxAge=2592000)](https://hex.pm/packages/mandate)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs-purple)](https://hexdocs.pm/mandate)

# Mandate

A declarative framework for building robust, elegant command-line interfaces (CLIs), standalone commands, and Mix/Igniter tasks in Elixir with minimal boilerplate.

Built on top of [Spark](https://hexdocs.pm/spark), Mandate lets you declare arguments, switches, defaults, and routing rules with a clean DSL.

---

## Key Features

- **Declarative CLI Router (`use Mandate`):** Route commands to inline handlers or dedicated command modules with automatic command name dispatch and kebab-case aliases.
- **Dedicated Subcommand Modules (`use Mandate.Command`):** Structure complex CLIs into clean, decoupled command modules.
- **Mix & Igniter Tasks (`use Mandate.Task`):** Build standard `Mix.Task` or composable `Igniter.Mix.Task` with declarative argument validation and automatic doc injection (`@shortdoc`, `@moduledoc`).
- **Rich Argument & Switch Types:** Built-in type parsing and validation for `string`, `integer`, `float`, `boolean`, `atom`, and `count` flags.
- **Task Generators:** Built-in generators to scaffold new tasks instantly (`mix mandate.gen.mix_task` and `mix mandate.gen.igniter_task`).

---

## Installation

Add `mandate` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mandate, "~> 0.3"}
  ]
end
```

---

## Usage

### 1. Building a Multi-Command CLI Router

Use `Mandate` in your main CLI module (e.g. for an `escript` application):

```elixir
defmodule MyApp.Cli do
  use Mandate

  commands default: :greet do
    command :greet do
      shortdoc "Greets a person"

      argument :name, :string do
        required true
        doc "Name of the person to greet"
      end

      switch :shout, :boolean do
        short :s
        default false
        doc "Shout the greeting"
      end

      run fn args ->
        greeting = "Hello, #{args.name}!"
        if args[:shout], do: String.upcase(greeting), else: greeting
      end
    end

    command :deploy, MyApp.Cli.Deploy
  end
end
```

Running the CLI:

```elixir
# Direct invocation
MyApp.Cli.main(["greet", "Alice"])
# => "Hello, Alice!"

MyApp.Cli.main(["greet", "Alice", "-s"])
# => "HELLO, ALICE!"

# Fallback to default command
MyApp.Cli.main(["Bob"])
# => "Hello, Bob!"
```

---

### 2. Dedicated Command Modules

For larger CLI commands, define them using `Mandate.Command`:

```elixir
defmodule MyApp.Cli.Deploy do
  use Mandate.Command

  shortdoc "Deploys application to an environment"

  argument :target, :string do
    required true
    doc "Deployment target (e.g. staging, prod)"
  end

  switch :replicas, :integer do
    short :r
    default 1
    doc "Number of replicas"
  end

  switch :dry_run, :boolean do
    default false
  end

  run fn args ->
    # Deployment logic
    "Deploying #{args.replicas} replicas to #{args.target} (dry_run: #{args.dry_run})"
  end
end
```

Register it in your router:

```elixir
defmodule MyApp.Cli do
  use Mandate

  commands do
    command :deploy, MyApp.Cli.Deploy
  end
end
```

---

### 3. Mix and Igniter Tasks

Define Mix tasks with `use Mandate.Task`:

```elixir
defmodule Mix.Tasks.MyApp.Greet do
  use Mandate.Task, as: :mix

  shortdoc "Greets a user"
  longdoc "A Mix task that prints a personalized greeting"

  argument :name, :string do
    required true
  end

  switch :verbose, :boolean do
    short :v
  end

  run fn args ->
    if args[:verbose] do
      Mix.shell().info("Verbose: greeting #{args.name}")
    end

    Mix.shell().info("Hello, #{args.name}!")
  end
end
```

For composable Igniter tasks:

```elixir
defmodule Mix.Tasks.MyApp.Install do
  use Mandate.Task, as: :igniter

  shortdoc "Installs MyApp extensions"

  argument :extension, :string do
    required true
  end

  run fn igniter ->
    # Work with Igniter context
    igniter
  end
end
```

---

### 4. Generators

Scaffold new Mix and Igniter tasks with Mandate's built-in generators:

```bash
# Generate a standard Mix task
mix mandate.gen.mix_task my_app.my_task -a user_id:integer:required -s verbose:boolean:v

# Generate an Igniter task
mix mandate.gen.igniter_task my_app.install -a package:string:required
```

---

## License

MIT License

Copyright (c) 2025 Egor Kislitsyn
