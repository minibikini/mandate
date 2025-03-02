defmodule Mandate.Transformers.AddDocAttributes do
  use Spark.Dsl.Transformer

  def transform(dsl_state) do
    shortdoc =
      dsl_state
      |> Map.get([:root])
      |> Map.get(:entities)
      |> Enum.find(fn x -> is_struct(x, Mandate.Dsl.Shortdoc) end)
      |> Map.get(:shortdoc)

    bindings = [shortdoc: shortdoc]

    dsl_state =
      Spark.Dsl.Transformer.eval(
        dsl_state,
        bindings,
        quote do
          @shortdoc unquote(shortdoc)
        end
      )

    {:ok, dsl_state}
  end
end
