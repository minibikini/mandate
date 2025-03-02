defmodule Mandate.Dsl.Longdoc do
  @moduledoc false
  defstruct [:longdoc]

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :longdoc,
      args: [:longdoc],
      target: Mandate.Dsl.Longdoc,
      describe: "Multi-line description",
      schema: [
        longdoc: [
          type: :string,
          required: false
        ]
      ]
    }
end
