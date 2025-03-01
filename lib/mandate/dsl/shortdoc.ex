defmodule Mandate.Dsl.Shortdoc do
  defstruct [:shortdoc]

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :shortdoc,
      args: [:shortdoc],
      target: Mandate.Dsl.Shortdoc,
      describe: "One line description",
      schema: [
        shortdoc: [
          type: :string,
          required: false
        ]
      ]
    }
end
