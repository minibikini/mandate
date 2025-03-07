defmodule Mandate.Schema do
  @schema [
    run: [
      type: {:fun, 1},
      required: true,
      doc: """
      The function that will be called when the command/task is run. The function should accept a single argument, a keyword list of the parsed arguments and switches.

      Igniter tasks accept the Igniter context instead of the args.
      """,
      snippet: """
      fn args ->

      end
      """
    ],
    shortdoc: [
      type: :string,
      doc: "One line description"
    ],
    longdoc: [
      type: :string,
      doc: "Multi-line description"
    ],
    example: [
      type: :string,
      doc: "Task usage example"
    ]
  ]

  def take(keys) do
    Keyword.take(@schema, keys)
  end

  def merge(keys, list) do
    keys
    |> take()
    |> Keyword.merge(list)
  end
end
