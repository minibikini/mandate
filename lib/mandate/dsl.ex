defmodule Mandate.Dsl do
  @moduledoc false
  @root %Spark.Dsl.Section{
    name: :root,
    describe: "The root section",
    top_level?: true,
    schema: [
      run: [
        # type: {:one_of, [{:fun, 1}, {:fun, 2}]},
        type: {:fun, 2},
        required: true,
        doc: """
        The function that will be called when the command/task is run. The function should accept a single argument, a keyword list of the parsed arguments and switches.

        Igniter tasks also accept a second argument, the Igniter context.
        """,
        snippet: """
        fn args ->

        end
        """
      ],
      shortdoc: [
        type: :string,
        doc: "One line description"
      ],
      longdoc: [
        type: :string,
        doc: "Multi-line description"
      ]
    ],
    entities: [
      Mandate.Dsl.Argument.__entity__(),
      Mandate.Dsl.Switch.__entity__()
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@root],
    transformers: [Mandate.Transformers.AddDocAttributes],
    verifiers: [Spark.Dsl.Verifiers.VerifyEntityUniqueness]
end
