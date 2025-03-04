defmodule Mandate.MixTask do
  def init do
    quote do
      use Mix.Task

      @impl Mix.Task
      def run(argv) do
        root = Mandate.Info.root(__MODULE__)

        with {:ok, parsed} <- Mandate.OptionParser.parse_argv(root, argv),
             {:ok, run} <- Mandate.Info.root_run(__MODULE__) do
          run.(parsed, nil)
        else
          {:error, err} -> Mix.shell().error(err)
        end
      end
    end
  end
end
