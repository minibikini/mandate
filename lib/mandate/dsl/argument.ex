defmodule Mandate.Dsl.Argument do
  @moduledoc false
  defstruct [:__identifier__, :name, :type, :required, :doc]
  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :argument,
      args: [:name, {:optional, :type}],
      target: Mandate.Dsl.Argument,
      identifier: :name,
      describe: "A argument that can be passed to the task",
      schema: [
        name: [
          type: :atom,
          required: true
        ],
        type: [
          type: {:one_of, [:string, :integer, :float, :atom]},
          default: :string
        ],
        required: [
          type: :boolean,
          default: false
        ],
        example: [
          doc: "Example value for the argument"
        ],
        doc: [
          type: :string
        ]
      ]
    }
end
