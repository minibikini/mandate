defmodule Mandate.IgniterMixTask do
  def init do
    quote do
      use Igniter.Mix.Task

      @impl Igniter.Mix.Task
      def igniter(igniter) do
        root = Mandate.Info.root(__MODULE__)

        with {:ok, parsed} <- Mandate.OptionParser.parse_argv(root, igniter.args.argv),
             {:ok, run} <- Mandate.Info.root_run(__MODULE__) do
          run.(igniter, parsed)
        else
          {:error, err} ->
            Mix.shell().error(err)
            igniter
        end
      end
    end
  end
end
