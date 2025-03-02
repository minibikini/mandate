defmodule Mandate.Dsl.Description do
  @moduledoc false
  defstruct [:description]

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :description,
      args: [:description],
      target: Mandate.Dsl.Description,
      describe: "The command description, will be used in help output",
      schema: [
        description: [
          type: :string,
          required: false
        ]
      ]
    }
end
