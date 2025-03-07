defmodule Mandate.TaskDsl do
  @moduledoc false
  @task %Spark.Dsl.Section{
    name: :task,
    describe: "Task's root section",
    top_level?: true,
    schema: Mandate.Schema.take([:shortdoc, :longdoc, :example, :run]),
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
