defmodule Mandate.Dsl.Switch do
  defstruct [:name, :type, :required, :short, :doc]

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :switch,
      args: [:name, :type],
      target: Mandate.Dsl.Switch,
      describe: "A switch that can be passed to the task",
      schema: [
        name: [
          type: :atom,
          required: true
        ],
        type: [
          type: :atom,
          required: true
        ],
        default: [],
        short: [
          type: :string
        ],
        required: [
          type: :boolean,
          default: false
        ],
        doc: [
          type: :string
        ]
      ]
    }
end
