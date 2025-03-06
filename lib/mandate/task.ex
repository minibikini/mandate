defmodule Mandate.Task do
  use Spark.Dsl,
    default_extensions: [
      extensions: [Mandate.TaskDsl]
    ],
    opt_schema: [
      as: [
        type: {:one_of, [:mix, :igniter]}
      ]
    ]

  @impl Spark.Dsl
  def handle_opts(opts) do
    case Keyword.get(opts, :as) do
      :igniter -> igniter()
      _ -> mix()
    end
  end

  def mix do
    quote do
      use Mix.Task

      @impl Mix.Task
      def run(argv) do
        task = Mandate.Info.task(__MODULE__)

        with {:ok, parsed} <- Mandate.OptionParser.parse(argv, task),
             {:ok, run} <- Mandate.Info.task_run(__MODULE__) do
          run.(parsed)
        else
          {:error, err} -> Mix.shell().error(err)
        end
      end
    end
  end

  def igniter do
    quote do
      use Igniter.Mix.Task

      @impl Igniter.Mix.Task
      def igniter(igniter) do
        task = Mandate.Info.task(__MODULE__)

        with {:ok, parsed} <- Mandate.OptionParser.parse(igniter.args.argv, task),
             {:ok, run} <- Mandate.Info.task_run(__MODULE__) do
          run.(igniter)
        else
          {:error, err} ->
            Mix.shell().error(err)
            igniter
        end
      end

      @impl Igniter.Mix.Task
      def parse_argv(argv) do
        task = Mandate.Info.task(__MODULE__)

        parsed_argv = Mandate.OptionParser.parse_argv(argv, task)

        {_positional, argv_flags} = positional_args!(argv)

        with {:ok, pos_args} <- Mandate.OptionParser.parse_positional_args(task, parsed_argv),
             {:ok, switches} <- Mandate.OptionParser.parse_switches(parsed_argv, task),
             {:ok, switches} <- Mandate.OptionParser.set_switch_defaults(switches, task) do
          %Igniter.Mix.Task.Args{
            positional: pos_args,
            options: switches,
            argv: argv,
            argv_flags: argv_flags
          }
        else
          {:error, err} -> raise err
        end
      end
    end
  end
end
