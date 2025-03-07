defmodule Mandate.Schema do
  @schema [
    run: [
      type: {:or, [{:mfa_or_fun, 1}, {:mfa_or_fun, 2}]},
      required: false,
      doc: """
      Provide an anonymous function which implements a `run/1-2` callback. The function that will be called when the command/task is run.

      Cannot be provided at the same time as the `impl` argument.
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
