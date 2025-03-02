defmodule Mandate.Dsl do
  @root %Spark.Dsl.Section{
    name: :root,
    schema: [
      required: [
        type: {:list, :atom},
        doc: "The fields that must be provided for validation to succeed"
      ]
    ],
    entities: [
      Mandate.Dsl.Argument.__entity__(),
      Mandate.Dsl.Description.__entity__(),
      Mandate.Dsl.Run.__entity__(),
      Mandate.Dsl.Shortdoc.__entity__(),
      Mandate.Dsl.Switch.__entity__()
    ],
    describe: "Configure the fields that are supported and required",
    top_level?: true
  }

  use Spark.Dsl.Extension,
    sections: [@root],
    verifiers: [Mandate.Verifiers.VerifyRequired],
    transformers: [Mandate.Transformers.AddDocAttributes]
end
