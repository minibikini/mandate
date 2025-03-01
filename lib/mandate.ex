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
      :mix_task -> mix_task()
      _ -> quote(do: nil)
    end
  end

  defp mix_task() do
    quote do
      use Mix.Task
      # @moduledoc "Printed when the user requests `mix help echo`"
      # @shortdoc "Echoes arguments"
      # @persist {:simple_notifiers, unquote(opts[:simple_notifiers])}
      # @requirements ["app.config"]
      # @preferred_cli_env :test

      @impl Mix.Task
      def run(argv) do
        Mandate.Info.root(__MODULE__)
        |> IO.inspect()
      end
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
