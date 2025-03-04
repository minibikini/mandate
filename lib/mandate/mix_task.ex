defmodule Mandate.MixTask do
  def init do
    quote do
      use Mix.Task

      @impl Mix.Task
      def run(argv) do
        root = Mandate.Info.root(__MODULE__)

        case Mandate.OptionParser.parse_argv(root, argv) do
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
end
