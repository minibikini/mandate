defmodule Mandate do
  @moduledoc """
  Documentation for `Mandate`.
  """

  use Spark.Dsl,
    default_extensions: [
      extensions: [Mandate.Dsl]
    ],
    opt_schema: [
      as: [
        type: {:one_of, [:mix_task, :igniter_task]}
      ]
    ]

  @impl Spark.Dsl
  def handle_opts(opts) do
    case Keyword.get(opts, :as) do
      :mix_task -> Mandate.MixTask.init()
      :igniter_task -> Mandate.IgniterMixTask.init()
      _ -> quote(do: nil)
    end
  end
end
