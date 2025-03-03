defmodule Mandate.MixTask do
  def init do
    quote do
      use Mix.Task

      @impl Mix.Task
      def run(argv) do
        root = Mandate.Info.root(__MODULE__)

        case Mandate.MixTask.parse_argv(root, argv) do
          {:ok, parsed} -> Mandate.MixTask.run(root, parsed)
          {:error, err} -> Mix.shell().error(err)
        end
      end
    end
  end

  def run(root, parsed_argv) do
    root
    |> Enum.find(&is_struct(&1, Mandate.Dsl.Run))
    |> then(fn run -> apply(run.fun, [parsed_argv]) end)
  end

  def parse_argv(root, argv) do
    parsed_argv = OptionParser.parse(argv, parse_opts(root))

    with {:ok, switches} <- validate_switches(parsed_argv),
         {:ok, pos_args} <- validate_pos_args(root, parsed_argv) do
      {:ok, pos_args ++ switches}
    end
  end

  defp validate_switches({switches, _pos_args, []}), do: {:ok, switches}

  defp validate_switches({_switches, _pos_args, invalid}),
    do: {:error, "Invalid options: #{inspect(invalid)}"}

  defp validate_pos_args(root, {_, pos_args, _}) do
    pos_args_schema = Enum.filter(root, &is_struct(&1, Mandate.Dsl.Argument))
    pos_args_schema_required = Enum.filter(pos_args_schema, & &1.required)

    pos_args_len = length(pos_args)
    pos_args_schema_len = length(pos_args_schema)
    pos_args_schema_required_len = length(pos_args_schema_required)

    with :ok <- validate_required_pos_args(pos_args_schema_required_len, pos_args_len),
         :ok <- validate_pos_args_len(pos_args_len, pos_args_schema_len) do
      pos_args =
        pos_args
        |> Enum.zip(pos_args_schema)
        |> Enum.map(&parse_pos_arg/1)

      {:ok, pos_args}
    end
  end

  defp parse_pos_arg({arg, schema}) do
    value =
      case schema.type do
        :string -> arg
        :integer -> String.to_integer(arg)
        :float -> String.to_float(arg)
      end

    {schema.name, value}
  end

  defp validate_required_pos_args(pos_args_schema_required_len, pos_args_len) do
    if pos_args_schema_required_len > pos_args_len do
      {:error,
       "Wrong number of required arguments. Expected #{pos_args_schema_required_len} but got #{pos_args_len}."}
    else
      :ok
    end
  end

  defp validate_pos_args_len(pos_args_len, max) do
    if pos_args_len > max do
      {:error, "Too many arguments. Expected maximum #{max} but got #{pos_args_len}."}
    else
      :ok
    end
  end

  defp parse_opts(root) do
    root
    |> Enum.filter(&is_struct(&1, Mandate.Dsl.Switch))
    |> Enum.reduce([aliases: [], strict: []], fn switch, [aliases: aliases, strict: strict] ->
      strict = [{switch.name, switch.type} | strict]

      aliases =
        if switch.short do
          [{switch.short, switch.name} | aliases]
        else
          aliases
        end

      [aliases: aliases, strict: strict]
    end)
  end
end
