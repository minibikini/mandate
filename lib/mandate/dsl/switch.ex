defmodule Mandate.Dsl.Switch do
  @moduledoc false
  defstruct [:__identifier__, :name, :type, :required, :short, :keep, :doc]

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :switch,
      args: [:name, :type],
      identifier: :name,
      target: Mandate.Dsl.Switch,
      describe: "A switch that can be passed to the task",
      schema: [
        name: [
          type: :atom,
          required: true
        ],
        type: [
          type: {:one_of, [:boolean, :string, :integer, :float, :atom, :count]},
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
          doc: "keeps duplicate elements instead of overriding them",
          default: false
        ],
        doc: [
          type: :string
        ]
      ]
    }
end
