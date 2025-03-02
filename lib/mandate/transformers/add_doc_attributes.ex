defmodule Mandate.Transformers.AddDocAttributes do
  @moduledoc false
  use Spark.Dsl.Transformer

  def transform(dsl_state) do
    shortdoc =
      dsl_state
      |> Map.get([:root])
      |> Map.get(:entities)
      |> Enum.find(fn x -> is_struct(x, Mandate.Dsl.Shortdoc) end)
      |> Map.get(:shortdoc)

    # longdoc =
    #   dsl_state
    #   |> Map.get([:root])
    #   |> Map.get(:entities)
    #   |> Enum.find(fn x -> is_struct(x, Mandate.Dsl.Longdoc) end)
    #   |> Map.get(:longdoc)

    # %{moduledoc: {0, longdoc}, shortdoc: shortdoc}
    dsl_state =
      %{shortdoc: shortdoc}
      |> Map.reject(fn {_k, v} -> is_nil(v) end)
      |> Enum.reduce(dsl_state, fn {key, value}, dsl_state ->
        Spark.Dsl.Transformer.eval(
          dsl_state,
          [key: key, value: value],
          quote do
            Module.put_attribute(__MODULE__, unquote(key), unquote(value))
          end
        )
      end)

    {:ok, dsl_state}
  end
end
