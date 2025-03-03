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
        type: {:one_of, [:mix_task]}
      ]
    ]

  @impl Spark.Dsl
  def handle_opts(opts) do
    case Keyword.get(opts, :as) do
      :mix_task -> Mandate.MixTask.init()
      _ -> quote(do: nil)
    end
  end

  @doc """
  Hello world.

  ## Examples

      iex> Mandate.hello()
      :world

  """
  def hello do
    :world
  end
end
