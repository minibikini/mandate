defmodule Mandate.Dsl do
  @moduledoc false

  defmodule Command do
    defstruct [:__identifier__, :name, :module, :run, :shortdoc, :longdoc, options: []]
  end

  @command_schema Mandate.Schema.merge([:shortdoc, :longdoc, :example],
                    name: [type: :atom, required: true],
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

  @command %Spark.Dsl.Entity{
    name: :command,
    args: [:name, :module],
    identifier: :name,
    target: Command,
    describe: "Defines a CLI command",
    schema: @command_schema,
    entities: [
      options: [Mandate.Dsl.Argument.__entity__(), Mandate.Dsl.Switch.__entity__()]
    ]
  }

  @commands %Spark.Dsl.Section{
    name: :commands,
    describe: """
    A collection of commands
    """,
    examples: [
      """
      commands do
        command :main MyAppCli.Tweet
        command :hello do
          run fn _args ->
            IO.puts "Hello, World!"
          end
        end
      end
      """
    ],
    entities: [
      @command
    ],
    schema: [
      default: [
        type: :atom,
        default: :main,
        doc: "The default manufacturer"
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@commands],
    transformers: [Mandate.Transformers.AddDocAttributes],
    verifiers: [Spark.Dsl.Verifiers.VerifyEntityUniqueness]
end

# defmodule Reactor.Dsl do
#   @moduledoc false

#   alias Reactor.Dsl
#   alias Spark.Dsl.{Extension, Section}

#   @middleware %Section{
#     name: :middlewares,
#     describe: "Middleware to be added to the Reactor",
#     entities: [Dsl.Middleware.__entity__()],
#     patchable?: true
#   }

#   @reactor %Section{
#     name: :reactor,
#     describe: "The top-level reactor DSL",
#     schema: [
#       return: [
#         type: :atom,
#         required: false,
#         doc: """
#         Specify which step result to return upon completion.
#         """
#       ]
#     ],
#     entities: [
#       Dsl.Around.__entity__(),
#       Dsl.Collect.__entity__(),
#       Dsl.Compose.__entity__(),
#       Dsl.Debug.__entity__(),
#       Dsl.Flunk.__entity__(),
#       Dsl.Group.__entity__(),
#       Dsl.Input.__entity__(),
#       Dsl.Map.__entity__(),
#       Dsl.Step.__entity__(),
#       Dsl.Switch.__entity__(),
#       Dsl.Template.__entity__()
#     ],
#     sections: [@middleware],
#     top_level?: true,
#     patchable?: true
#   }

#   use Extension,
#     sections: [@reactor],
#     transformers: [Dsl.Transformer],
#     verifiers: [Dsl.Verifier]
# end
