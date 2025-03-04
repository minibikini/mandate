defmodule Mandate.MixTask do
  def init do
    quote do
      use Mix.Task

      @impl Mix.Task
      def run(argv) do
        root = Mandate.Info.root(__MODULE__)

        with {:ok, parsed} <- Mandate.OptionParser.parse_argv(root, argv),
             {:ok, run} <- Mandate.Info.root_run(__MODULE__) do
          run.(parsed)
        else
          {:error, err} -> Mix.shell().error(err)
        end
      end

      # case Mandate.OptionParser.parse_argv(root, argv) do
      #   {:ok, parsed} -> Mandate.Info.root_run!(__MODULE__, parsed)
      #   {:error, err} -> Mix.shell().error(err)
      # end
    end
  end
end

# def run(root, parsed_argv) do
#   root
#   |> Enum.find(&is_struct(&1, Mandate.Dsl.Run))
#   |> then(fn run -> apply(run.fun, [parsed_argv]) end)
# end
# end
