defmodule Mandate.Dsl.Argument do
  defstruct [:name, :type, :required, :doc]
  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :argument,
      args: [:name, :type],
      target: Mandate.Dsl.Argument,
      describe: "A argument that can be passed to the task",
      schema: [
        name: [
          type: :atom,
          required: true
        ],
        type: [
          type: :atom,
          required: true
        ],
        required: [
          type: :boolean,
          default: true
        ],
        doc: [
          type: :string
        ]
      ]
    }
end
