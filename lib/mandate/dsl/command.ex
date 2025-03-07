# defmodule Mandate.Dsl.Command do
#   @moduledoc false
#   defstruct [:__identifier__, :name]

#   @schema Mandate.Schema.merge([:shortdoc, :longdoc, :run, :example],
#             name: [
#               type: :atom,
#               required: true
#             ]
#           )

#   @doc false
#   def __entity__,
#     do: %Spark.Dsl.Entity{
#       name: :command,
#       args: [:name],
#       identifier: :name,
#       target: Mandate.Dsl.Command,
#       describe: "Defines a CLI command",
#       schema: @schema,
#       entities: [
#         arguments: [Mandate.Dsl.Argument.__entity__()],
#         switches: [Mandate.Dsl.Switch.__entity__()]
#       ]
#     }
# end
