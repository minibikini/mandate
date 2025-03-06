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
        type: {:one_of, [:mix_task, :igniter_task]}
      ]
    ]

  @impl Spark.Dsl
  def handle_opts(opts) do
    case Keyword.get(opts, :as) do
      :mix_task -> Mandate.MixTask.init()
      :igniter_task -> Mandate.IgniterMixTask.init()
      _ -> run(opts)
    end
  end

  def run(_opts) do
    quote do
      def main(argv) do
        root = Mandate.Info.root(__MODULE__)

        with {:ok, parsed} <- Mandate.OptionParser.parse(argv, root),
             {:ok, run} <- Mandate.Info.root_run(__MODULE__) do
          run.(parsed, nil)
        else
          {:error, err} -> IO.puts(:stderr, "Error: #{inspect(err)}")
        end
      end
    end
  end
end
