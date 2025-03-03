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
    {_switches, pos_args, _err} =
      OptionParser.parse(argv, strict: [debug: :boolean])

    pos_args_shema = Enum.filter(root, &is_struct(&1, Mandate.Dsl.Argument))
    pos_args_shema_required = Enum.filter(pos_args_shema, & &1.required)

    pos_args_len = length(pos_args)
    pos_args_schema_len = length(pos_args_shema)
    pos_args_shema_required_len = length(pos_args_shema_required)

    error_message =
      cond do
        pos_args_shema_required_len > pos_args_len ->
          "Wrong number of required arguments. Expected #{pos_args_shema_required_len} but got #{pos_args_len}."

        pos_args_schema_len < pos_args_len ->
          "Too many arguments. Expected maximum #{pos_args_schema_len} but got #{pos_args_len}."

        true ->
          nil
      end

    if is_binary(error_message), do: {:error, error_message}, else: {:ok, pos_args}
  end
end
