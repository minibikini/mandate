defmodule Mandate.OptionParser do
  @moduledoc false

  alias Mandate.Dsl.Argument
  alias Mandate.Dsl.Switch

  def parse(argv, command) do
    parsed_argv = parse_argv(argv, command)

    with {:ok, pos_args} <- parse_positional_args(command, parsed_argv),
         {:ok, switches} <- parse_switches(parsed_argv, command),
         {:ok, switches} <- set_switch_defaults(switches, command) do
      {:ok, Map.merge(pos_args, Map.new(switches))}
    end
  end

  def parse_argv(argv, command) do
    OptionParser.parse(argv, section_to_parse_opts(command))
  end

  def set_switch_defaults(switches, command) do
    clean_switches = Keyword.reject(switches, fn {_key, value} -> is_nil(value) end)
    schemas = switch_schemas(command)

    switches_with_defaults =
      Enum.reduce(schemas, clean_switches, fn schema, acc ->
        default = get_default_value(schema)
        Keyword.put_new(acc, schema.name, maybe_wrap_value(schema, default))
      end)

    missing_switch =
      schemas
      |> Enum.filter(& &1.required)
      |> Enum.find(fn schema -> is_nil(switches_with_defaults[schema.name]) end)

    case missing_switch do
      nil -> {:ok, switches_with_defaults}
      schema -> {:error, "Missing required switch: #{inspect(schema.name)}"}
    end
  end

  defp get_default_value(%{type: :boolean, default: nil}), do: false
  defp get_default_value(%{default: nil}), do: nil
  defp get_default_value(%{default: value}), do: value

  defp maybe_wrap_value(%{keep: true}, nil), do: []
  defp maybe_wrap_value(%{keep: true}, value), do: List.wrap(value)
  defp maybe_wrap_value(_schema, value), do: value

  def parse_switches({switches, _pos_args, []}, command),
    do: {:ok, command |> switch_schemas() |> Enum.map(&parse_switch(&1, switches))}

  def parse_switches({_switches, _pos_args, invalid}, _command) do
    invalid = Enum.map(invalid, fn {flag, _} -> flag end)

    {:error, "Invalid options: #{inspect(invalid)}"}
  end

  @spec parse_positional_args(list(), {term(), list(), term()}) ::
          {:ok, map()} | {:error, String.t()}
  def parse_positional_args(command, {_, pos_args, _}) do
    pos_args_schema = Enum.filter(command, &is_struct(&1, Argument))
    pos_args_schema_required = Enum.filter(pos_args_schema, & &1.required)

    pos_args_len = length(pos_args)
    pos_args_schema_len = length(pos_args_schema)
    pos_args_schema_required_len = length(pos_args_schema_required)

    with :ok <- validate_required_pos_args(pos_args_schema_required_len, pos_args_len),
         :ok <- validate_pos_args_len(pos_args_len, pos_args_schema_len) do
      parsed_pos_args =
        pos_args |> Enum.zip(pos_args_schema) |> Enum.map(&parse_pos_arg/1) |> Map.new()

      {:ok, parsed_pos_args}
    end
  end

  defp parse_pos_arg({arg, %{name: name, type: :string}}), do: {name, arg}
  defp parse_pos_arg({arg, %{name: name, type: :integer}}), do: {name, String.to_integer(arg)}
  defp parse_pos_arg({arg, %{name: name, type: :float}}), do: {name, String.to_float(arg)}
  defp parse_pos_arg({arg, %{name: name, type: :atom}}), do: {name, String.to_existing_atom(arg)}

  defp parse_switch(%{name: name, keep: true, type: :atom}, switches) do
    {name,
     switches
     |> Keyword.take([name])
     |> Keyword.values()
     |> Enum.map(&String.to_existing_atom/1)}
  end

  defp parse_switch(%{name: name, keep: true}, switches),
    do: {name, switches |> Keyword.take([name]) |> Keyword.values()}

  defp parse_switch(%{name: name, type: :atom}, switches),
    do: {name, switches |> Keyword.get(name) |> String.to_existing_atom()}

  defp parse_switch(%{name: name}, switches),
    do: {name, switches |> Keyword.get(name)}

  defp validate_required_pos_args(pos_args_schema_required_len, pos_args_len)
       when pos_args_schema_required_len <= pos_args_len,
       do: :ok

  defp validate_required_pos_args(pos_args_schema_required_len, pos_args_len),
    do:
      {:error,
       "Wrong number of required arguments. Expected #{pos_args_schema_required_len} but got #{pos_args_len}."}

  defp validate_pos_args_len(pos_args_len, max) when pos_args_len <= max, do: :ok

  defp validate_pos_args_len(pos_args_len, max),
    do: {:error, "Too many arguments. Expected maximum #{max} but got #{pos_args_len}."}

  defp switch_schemas(command) do
    Enum.filter(command, &is_struct(&1, Switch))
  end

  def section_to_parse_opts(command) do
    command
    |> switch_schemas()
    |> Enum.reduce([aliases: [], strict: []], &switch_to_parse_opts/2)
  end

  defp switch_to_parse_opts(switch, aliases: aliases, strict: strict),
    do: [aliases: switch_to_alias(switch, aliases), strict: switch_to_strict(switch, strict)]

  defp switch_to_strict(switch, strict), do: [switch_to_schema(switch) | strict]

  defp switch_to_alias(%Switch{short: nil}, aliases), do: aliases
  defp switch_to_alias(%Switch{short: short, name: name}, aliases), do: [{short, name} | aliases]

  defp switch_to_schema(%Switch{name: name, type: type, keep: true}),
    do: {name, [maybe_as_string(type), :keep]}

  defp switch_to_schema(%Switch{name: name, type: type}), do: {name, maybe_as_string(type)}

  defp maybe_as_string(:atom), do: :string
  defp maybe_as_string(type), do: type
end
