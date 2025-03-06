defmodule Mandate do
  @moduledoc """
  Documentation for `Mandate`.
  """

  use Spark.Dsl,
    default_extensions: [
      extensions: [Mandate.Dsl]
    ]

  quote do
    def main(argv) do
      root = Mandate.Info.root(__MODULE__)

      with {:ok, parsed} <- Mandate.OptionParser.parse(argv, root),
           {:ok, run} <- Mandate.Info.root_run(__MODULE__) do
        run.(parsed)
      else
        {:error, err} -> IO.puts(:stderr, "Error: #{inspect(err)}")
      end
    end
  end
end
