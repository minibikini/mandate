defmodule Mandate.Dsl.Command do
  @moduledoc false
  defstruct [:__identifier__, :name, :impl, :run, :shortdoc, :longdoc, options: []]

  @command_schema Mandate.Schema.merge([:shortdoc, :longdoc, :example],
                    name: [type: :atom, required: true],
                    impl: [
                      type: {:or, [{:spark_behaviour, Mandate.Command}, nil]},
                      required: false,
                      doc: """
                      A module that implements the `Reactor.Step` behaviour that provides the implementation.
                      """
                    ],
                    module: [type: :atom],
                    run: [
                      type: {:fun, 1},
                      # required: true,
                      doc: """
                      The function that will be called when the command/task is run. The function should accept a single argument, a keyword list of the parsed arguments and switches.

                      Igniter tasks accept the Igniter context instead of the args.
                      """,
                      snippet: """
                      fn args ->

                      end
                      """
                    ]
                  )

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :command,
      args: [:name, {:optional, :impl}],
      # not sure what `no_depend_modules` does, copied from `lib/reactor/dsl/step.ex`
      #
      # recursive_as: :commands,
      no_depend_modules: [:impl],
      identifier: :name,
      target: Command,
      describe: "Defines a CLI command",
      schema: @command_schema,
      entities: [
        options: [
          Mandate.Dsl.Argument.__entity__(),
          Mandate.Dsl.Switch.__entity__()
        ]
      ]
    }
end
