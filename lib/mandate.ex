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

  def get(module, :shortdoc) do
    module
    |> Mandate.Info.root()
    |> Enum.find(&is_struct(&1, Mandate.Dsl.Shortdoc))
  end

  defp mix_task() do
    quote do
      use Mix.Task

      @impl Mix.Task
      def run(argv) do
        __MODULE__
        |> Mandate.Info.root()
        |> Enum.find(&is_struct(&1, Mandate.Dsl.Run))
        |> then(fn run -> apply(run.fun, [argv]) end)
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
