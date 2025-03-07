# defmodule Mandate.Dsl.Commands do
#   @moduledoc false
#   defstruct [:__identifier__, :name, :type, :required, :default, :short, :keep, :doc]

#   @doc false
#   def __entity__,
#     do: %Spark.Dsl.Section{
#       name: :commands,
#       describe: "A collection of commands",
#       # args: [:name, {:optional, :type}],
#       # identifier: :name,
#       # target: Mandate.Dsl.Commands,
#       schema: [
#         name: [
#           type: :atom
#         ]
#       ],
#       entities: [
#         Mandate.Dsl.Command.__entity__()
#       ]
#     }
# end
