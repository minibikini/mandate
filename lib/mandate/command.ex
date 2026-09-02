defmodule Mandate.Command do
  @moduledoc """
  DSL for defining standalone CLI subcommands.

  ## Example

  ```elixir
  defmodule MyApp.Cli.Deploy do
    use Mandate.Command

    shortdoc "Deploys application to a target environment"

    argument :target, :string do
      required true
      doc "Deployment environment (e.g. staging, prod)"
    end

    switch :replicas, :integer do
      short :r
      default 1
    end

    run fn args ->
      "Deploying \#{args.replicas} replicas to \#{args.target}"
    end
  end
  ```
  """

  defmodule Dsl do
    @moduledoc false
    @mod %Spark.Dsl.Section{
      name: :mod,
      describe: "Command's root section",
      top_level?: true,
      schema: Mandate.Schema.take([:shortdoc, :longdoc, :example, :run]),
      entities: [
        Mandate.Dsl.Argument.__entity__(),
        Mandate.Dsl.Switch.__entity__()
      ]
    }

    use Spark.Dsl.Extension,
      sections: [@mod],
      transformers: [Mandate.Transformers.AddDocAttributes],
      verifiers: [Spark.Dsl.Verifiers.VerifyEntityUniqueness]
  end

  defmodule Info do
    @moduledoc false
    use Spark.InfoGenerator, extension: Dsl, sections: [:mod]
  end

  use Spark.Dsl,
    default_extensions: [
      extensions: [Dsl]
    ]
end
