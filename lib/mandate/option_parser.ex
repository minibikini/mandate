defmodule Mandate.OptionParser do
  @moduledoc false

  alias Mandate.Dsl.Argument
  alias Mandate.Dsl.Switch

  def parse_argv(root, argv) do
    parsed_argv = OptionParser.parse(argv, section_to_parse_opts(root))

    with {:ok, pos_args} <- validate_pos_args(root, parsed_argv),
         {:ok, switches} <- validate_switches(parsed_argv),
         {:ok, switches} <- set_switch_defaults(switches, root) do
      {:ok, pos_args ++ switches}
    end
  end

  defp set_switch_defaults(switches, root) do
    switches =
      root
      |> switch_schemas()
      |> Enum.reduce(switches, fn schema, switches ->
        if Keyword.has_key?(switches, schema.name) do
          switches
        else
          case schema do
            %{type: :boolean, default: nil} -> [{schema.name, false} | switches]
            %{default: nil} -> switches
            %{default: value} -> [{schema.name, value} | switches]
          end
        end
      end)

    {:ok, switches}
  end

  defp validate_switches({switches, _pos_args, []}), do: {:ok, switches}

  defp validate_switches({_switches, _pos_args, invalid}),
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

  defp switch_to_schema(%Switch{name: name, type: type, keep: true}), do: {name, [type, :keep]}
  defp switch_to_schema(%Switch{name: name, type: type}), do: {name, type}
end
