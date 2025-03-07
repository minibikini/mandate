defmodule Mandate do
  @moduledoc """
  Documentation for `Mandate`.
  """

  use Spark.Dsl,
    default_extensions: [
      extensions: [Mandate.Dsl]
    ]

  def handle_before_compile(_opts) do
    IO.inspect(__MODULE__, label: "handle_before_compile")

    quote do
      def main(argv) do
        IO.inspect({__MODULE__, argv}, label: "argv")

        commands =
          Spark.Dsl.Extension.get_entities(__MODULE__, [:commands])
          |> Enum.map(fn cmd ->
            if Spark.Dsl.is?(cmd.module, Mandate.Command) do
              # Spark.Dsl.Extension.get_

              Mandate.Command.Info.mod(cmd.module) |> IO.inspect(label: "modd")

              state = Spark.Dsl.Extension.get_entities(cmd.module, [:mod])
              IO.inspect({cmd.name, cmd.module, state})

              cmd
            else
              cmd
            end
          end)
          |> IO.inspect()

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
