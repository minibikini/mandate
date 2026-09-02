defmodule Mandate do
  @moduledoc """
  A declarative framework for building CLI command routers.

  Use `Mandate` in your application's entry module to define commands and dispatch
  command-line arguments:

  ```elixir
  defmodule MyApp.Cli do
    use Mandate

    commands default: :greet do
      command :greet do
        shortdoc "Greets a person"

        argument :name, :string do
          required true
        end

        switch :shout, :boolean

        run fn args ->
          greeting = "Hello, \#{args.name}"
          if args[:shout], do: String.upcase(greeting), else: greeting
        end
      end

      command :deploy, MyApp.Cli.Deploy
    end
  end
  ```
  """

  use Spark.Dsl,
    default_extensions: [
      extensions: [Mandate.Dsl]
    ]

  def handle_before_compile(_opts) do
    quote do
      def main(argv) do
        Mandate.dispatch(__MODULE__, argv)
      end
    end
  end

  @doc """
  Dispatches CLI arguments to the appropriate command configured in the router module.
  """
  def dispatch(router_module, argv) when is_list(argv) do
    commands = Spark.Dsl.Extension.get_entities(router_module, [:commands])
    default_name = Spark.Dsl.Extension.get_opt(router_module, [:commands], :default, :main)

    case argv do
      [command_name | rest] ->
        dispatch_named_or_default(commands, default_name, command_name, rest, argv)

      [] ->
        dispatch_default_or_error(commands, default_name)
    end
  end

  defp dispatch_named_or_default(commands, default_name, command_name, rest, full_argv) do
    case find_command(commands, command_name) do
      {:ok, cmd} ->
        execute_command(cmd, rest)

      :error ->
        case find_command_by_name(commands, default_name) do
          {:ok, default_cmd} ->
            execute_command(default_cmd, full_argv)

          :error ->
            {:error, "Unknown command: #{command_name}"}
        end
    end
  end

  defp dispatch_default_or_error(commands, default_name) do
    case find_command_by_name(commands, default_name) do
      {:ok, default_cmd} ->
        execute_command(default_cmd, [])

      :error ->
        {:error, "No command provided"}
    end
  end

  defp find_command(commands, name_str) when is_binary(name_str) do
    Enum.find_value(commands, :error, fn cmd ->
      cmd_str = to_string(cmd.name)
      kebab_str = String.replace(cmd_str, "_", "-")

      if name_str == cmd_str or name_str == kebab_str do
        {:ok, cmd}
      end
    end)
  end

  defp find_command_by_name(commands, name) when is_atom(name) do
    case Enum.find(commands, &(&1.name == name)) do
      nil -> :error
      cmd -> {:ok, cmd}
    end
  end

  defp execute_command(cmd, argv) do
    {entities, run_fn} = extract_command_details(cmd)

    case Mandate.OptionParser.parse(argv, entities) do
      {:ok, parsed_args} ->
        if is_function(run_fn, 1) do
          run_fn.(parsed_args)
        else
          {:ok, parsed_args}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp extract_command_details(%Mandate.Dsl.Command{
         impl: impl,
         module: module,
         options: options,
         run: run
       }) do
    target_module = resolve_target_module(impl, module)

    if target_module && Spark.Dsl.is?(target_module, Mandate.Command) do
      entities = Spark.Dsl.Extension.get_entities(target_module, [:mod])
      {entities, resolve_mod_run(target_module)}
    else
      {options || [], run}
    end
  end

  defp resolve_target_module({mod, _opts}, _fallback), do: mod
  defp resolve_target_module(mod, _fallback) when is_atom(mod) and not is_nil(mod), do: mod
  defp resolve_target_module(nil, fallback), do: fallback

  defp resolve_mod_run(module) do
    case Mandate.Command.Info.mod_run(module) do
      {:ok, f} -> f
      _ -> nil
    end
  end
end
