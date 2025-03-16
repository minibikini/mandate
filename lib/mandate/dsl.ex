defmodule Mandate.Dsl do
  @moduledoc false

  @commands %Spark.Dsl.Section{
    name: :commands,
    describe: """
    A collection of commands
    """,
    examples: [
      """
      commands do
        command :main MyAppCli.Tweet
        command :hello do
          run fn _args ->
            IO.puts "Hello, World!"
          end
        end
      end
      """
    ],
    entities: [
      Mandate.Dsl.Command.__entity__()
    ],
    schema: [
      default: [
        type: :atom,
        default: :main,
        doc: "The default manufacturer"
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@commands],
    transformers: [Mandate.Transformers.AddDocAttributes],
    verifiers: [Spark.Dsl.Verifiers.VerifyEntityUniqueness]
end
