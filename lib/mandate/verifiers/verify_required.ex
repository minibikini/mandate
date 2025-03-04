defmodule Mandate.Verifiers.VerifyRequired do
  @moduledoc false
  use Spark.Dsl.Verifier

  alias Spark.Error.DslError

  def verify(dsl_state) do
    IO.inspect(dsl_state)
    |> Spark.Dsl.Verifier.fetch_option([:root], :run)
    |> IO.inspect()

    with :ok <- verify_run(dsl_state) do
      :ok
    end

    :ok
  end

  defp verify_run(dsl_state) do
    entities = get_entities(dsl_state)

    if Enum.any?(entities, &is_struct(&1, Mandate.Dsl.Run)) do
      :ok
    else
      message = """
      No `run` function defined. Add something like:

          run fn args ->
            IO.puts("Running my task  with: \#{inspect(args)}"
          end

      """

      build_error(dsl_state, message, [:root, :entities, :run])
    end

    :ok
  end

  defp build_error(state, message, path) do
    {:error,
     DslError.exception(
       message: message,
       module: Spark.Dsl.Verifier.get_persisted(state, :module),
       path: path
     )}
  end

  defp get_entities(dsl_state) do
    Map.get(dsl_state, [:root]) |> Map.get(:entities)
  end
end
