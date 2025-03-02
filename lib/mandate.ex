defmodule Mandate do
  @moduledoc """
  Documentation for `Mandate`.
  """

  use Spark.Dsl,
    default_extensions: [
      extensions: [Mandate.Dsl]
    ],
    opt_schema: [
      as: [
        type: {:one_of, [:mix_task]}
      ]
    ]

  @impl Spark.Dsl
  def handle_opts(opts) do
    case Keyword.get(opts, :as) do
      :mix_task -> mix_task()
      _ -> quote(do: nil)
    end
  end

  defp mix_task do
    quote do
      use Mix.Task

      @impl Mix.Task
      def run(argv) do
        root = Mandate.Info.root(__MODULE__)
        argv = Mandate.parse_argv!(root, argv)

        root
        |> Enum.find(&is_struct(&1, Mandate.Dsl.Run))
        |> then(fn run -> apply(run.fun, [argv]) end)
      end
    end
  end

  def parse_argv!(root, argv) do
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

    if is_binary(error_message), do: raise(error_message)

    pos_args
  end

  @doc """
  Hello world.

  ## Examples

      iex> Mandate.hello()
      :world

  """
  def hello do
    :world
  end
end
