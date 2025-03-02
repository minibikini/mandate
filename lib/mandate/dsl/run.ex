defmodule Mandate.Dsl.Run do
  @moduledoc false
  defstruct [:fun]

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :run,
      args: [:fun],
      target: Mandate.Dsl.Run,
      schema: [
        fun: [
          type: {:fun, 1},
          required: false
        ]
      ]
    }
end
