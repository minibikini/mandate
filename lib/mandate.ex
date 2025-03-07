defmodule Mandate do
  @moduledoc """
  Documentation for `Mandate`.
  """

  use Spark.Dsl,
    default_extensions: [
      extensions: [Mandate.Dsl]
    ]

  def handle_before_compile(_opts) do
    quote do
      def main(argv) do
        IO.inspect(argv, label: "mod")
        # Spark.Dsl.Builder.
        # Mandate.Info.
        # Mandate.Info.
        # _mandate = Mandate.Info.mandate(__MODULE__) |> IO.inspect()

        # with {:ok, parsed} <- Mandate.OptionParser.parse(argv, mandate),
        #      {:ok, run} <- Mandate.Info.mandate_run(__MODULE__) do
        #   run.(parsed)
        # else
        #   {:error, err} -> IO.puts(:stderr, "Error: #{inspect(err)}")
        # end
      end
    end
  end
end
