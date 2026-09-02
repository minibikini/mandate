defmodule Mandate.Transformers.AddDocAttributes do
  @moduledoc false
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def transform(dsl_state) do
    longdoc = Transformer.get_option(dsl_state, [:task], :longdoc, false)
    shortdoc = Transformer.get_option(dsl_state, [:task], :shortdoc, false)

    dsl_state =
      %{moduledoc: {1, longdoc}, shortdoc: shortdoc}
      |> Map.reject(fn {_k, v} -> is_nil(v) end)
      |> Enum.reduce(dsl_state, fn {key, value}, dsl_state ->
        Transformer.eval(
          dsl_state,
          [key: key, value: value],
          quote do
            Module.register_attribute(__MODULE__, unquote(key), persist: true)
            Module.put_attribute(__MODULE__, unquote(key), unquote(value))
          end
        )
      end)

    {:ok, dsl_state}
  end
end
