defmodule Mandate.OptionParser do
  @moduledoc false

  alias Mandate.Dsl.Argument
  alias Mandate.Dsl.Switch

  def parse_argv(root, argv) do
    parsed_argv = OptionParser.parse(argv, section_to_parse_opts(root))

    with {:ok, pos_args} <- validate_pos_args(root, parsed_argv),
         {:ok, switches} <- parse_switches(parsed_argv, root),
         {:ok, switches} <- set_switch_defaults(switches, root) do
      {:ok, pos_args ++ switches}
    end
  end

  defp set_switch_defaults(switches, root) do
    clean_switches = Keyword.reject(switches, fn {_key, value} -> is_nil(value) end)
    schemas = switch_schemas(root)

    switches_with_defaults =
      Enum.reduce(schemas, clean_switches, fn schema, acc ->
        default = get_default_value(schema)
        Keyword.put_new(acc, schema.name, maybe_wrap_value(schema, default))
      end)

    {:ok, switches_with_defaults}
  end

  defp get_default_value(%{type: :boolean, default: nil}), do: false
  defp get_default_value(%{default: nil}), do: nil
  defp get_default_value(%{default: value}), do: value

  defp maybe_wrap_value(%{keep: true}, nil), do: []
  defp maybe_wrap_value(%{keep: true}, value), do: List.wrap(value)
  defp maybe_wrap_value(_schema, value), do: value

  defp parse_switches({switches, _pos_args, []}, root),
    do: {:ok, root |> switch_schemas() |> Enum.map(&parse_switch(&1, switches))}

  defp parse_switches({_switches, _pos_args, invalid}, _root),
    do: {:error, "Invalid options: #{inspect(invalid)}"}

  defp validate_pos_args(root, {_, pos_args, _}) do
    pos_args_schema = Enum.filter(root, &is_struct(&1, Argument))
    pos_args_schema_required = Enum.filter(pos_args_schema, & &1.required)

    pos_args_len = length(pos_args)
    pos_args_schema_len = length(pos_args_schema)
    pos_args_schema_required_len = length(pos_args_schema_required)

    with :ok <- validate_required_pos_args(pos_args_schema_required_len, pos_args_len),
         :ok <- validate_pos_args_len(pos_args_len, pos_args_schema_len) do
      {:ok, pos_args |> Enum.zip(pos_args_schema) |> Enum.map(&parse_pos_arg/1)}
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

  defp switch_schemas(root) do
    Enum.filter(root, &is_struct(&1, Switch))
  end

  defp section_to_parse_opts(root) do
    root
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
