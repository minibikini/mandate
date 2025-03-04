defmodule Mandate.Dsl do
  @moduledoc false
  @root %Spark.Dsl.Section{
    # auto_set_fields: term(),
    # deprecations: term(),
    # describe: term(),
    # docs: term(),
    # entities: term(),
    # examples: term(),
    # imports: term(),
    # links: term(),
    # modules: term(),
    # name: term(),
    # no_depend_modules: term(),
    # patchable?: term(),
    # schema: term(),
    # sections: term(),
    # snippet: term(),
    # top_level?: term()

    name: :root,
    schema: [
      run: [
        # type: {:one_of, [{:fun, 1}, {:fun, 2}]},
        type: {:fun, 1},
        required: true,
        doc: """
        The function that will be called when the command/task is run. The function should accept a single argument, a keyword list of the parsed arguments and switches.

        Igniter tasks also accept a second argument, the Igniter context.
        """,
        snippet: """
        fn args ->

        end
        """
      ]
    ],
    entities: [
      Mandate.Dsl.Argument.__entity__(),
      Mandate.Dsl.Description.__entity__(),
      Mandate.Dsl.Longdoc.__entity__(),
      # Mandate.Dsl.Run.__entity__(),
      Mandate.Dsl.Shortdoc.__entity__(),
      Mandate.Dsl.Switch.__entity__()
    ],
    describe: "Configure the fields that are supported and required",
    top_level?: true
  }

  use Spark.Dsl.Extension,
    sections: [@root],
    # verifiers: [Mandate.Verifiers.VerifyRequired],
    transformers: [Mandate.Transformers.AddDocAttributes]
end
