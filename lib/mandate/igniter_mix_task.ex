defmodule Mandate.IgniterMixTask do
  def init do
    quote do
      use Igniter.Mix.Task

      @impl Igniter.Mix.Task
      def igniter(igniter) do
        root = Mandate.Info.root(__MODULE__)

        with {:ok, parsed} <- Mandate.OptionParser.parse(igniter.args.argv, root),
             {:ok, run} <- Mandate.Info.root_run(__MODULE__) do
          run.(igniter, parsed)
        else
          {:error, err} ->
            Mix.shell().error(err)
            igniter
        end
      end

      @impl Igniter.Mix.Task
      def parse_argv(argv) do
        root = Mandate.Info.root(__MODULE__)

        parsed_argv = Mandate.OptionParser.parse_argv(argv, root)

        {_positional, argv_flags} = positional_args!(argv)

        with {:ok, pos_args} <- Mandate.OptionParser.parse_positional_args(root, parsed_argv),
             {:ok, switches} <- Mandate.OptionParser.parse_switches(parsed_argv, root),
             {:ok, switches} <- Mandate.OptionParser.set_switch_defaults(switches, root) do
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
