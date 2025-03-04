defmodule Mandate.Dsl.Switch do
  @moduledoc false
  defstruct [:name, :type, :required, :short, :keep, :doc]

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
          default: :boolean
        ],
        default: [],
        short: [
          type: :atom
        ],
        required: [
          type: :boolean,
          default: false
        ],
        keep: [
          type: :boolean,
          default: false
        ],
        doc: [
          type: :string
        ]
      ]
    }
end
