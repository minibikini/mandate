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

    fields = Enum.filter(root, &is_struct(&1, Mandate.Dsl.Argument))
    fields_required = Enum.filter(fields, & &1.required)

    pos_args_len = length(pos_args)
    fields_len = length(fields)
    fields_required_len = length(fields_required)

    error_message =
      cond do
        fields_required_len > pos_args_len ->
          "Wrong number of required arguments. Expected #{fields_required_len} but got #{pos_args_len}."

        fields_len < pos_args_len ->
          "Too many arguments. Expected maximum #{fields_len} but got #{pos_args_len}."

        true ->
          nil
      end

    if is_binary(error_message), do: {:error, error_message}, else: {:ok, pos_args}
  end
end
