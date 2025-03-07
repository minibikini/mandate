defmodule Mandate.Command do
  defmodule Dsl do
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
    use Spark.InfoGenerator, extension: Dsl, sections: [:mod]
  end

  use Spark.Dsl,
    default_extensions: [
      extensions: [Dsl]
    ]
end
