defmodule Mandate.TaskDsl do
  @moduledoc false
  @task %Spark.Dsl.Section{
    name: :task,
    describe: "Task's root section",
    top_level?: true,
    schema: [
      run: [
        type: {:fun, 1},
        required: true,
        doc: """
        The function that will be called when the command/task is run. The function should accept a single argument, a keyword list of the parsed arguments and switches.

        Igniter tasks accept the Igniter context instead of the args.
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
      ],
      example: [
        type: :string,
        doc: "Task usage example"
      ]
    ],
    entities: [
      Mandate.Dsl.Argument.__entity__(),
      Mandate.Dsl.Switch.__entity__()
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@task],
    transformers: [Mandate.Transformers.AddDocAttributes],
    verifiers: [Spark.Dsl.Verifiers.VerifyEntityUniqueness]
end
