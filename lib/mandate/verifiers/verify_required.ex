defmodule Mandate.Verifiers.VerifyRequired do
  use Spark.Dsl.Verifier

  alias Spark.Error.DslError

  def verify(dsl_state) do
    with :ok <- verify_run(dsl_state) do
      :ok
    end
  end

  defp verify_run(dsl_state) do
    if Enum.any?(get_entities(dsl_state), &is_struct(&1, Mandate.Dsl.Run)) do
      :ok
    else
      message = """
      No `run` function defined. Add something like:

          run fn args ->
            IO.puts("Running my task  with: \#{inspect(args)}"
          end
      """

      {:error,
       DslError.exception(
         message: message,
         module: Spark.Dsl.Verifier.get_persisted(dsl_state, :module),
         path: [:root, :entities, :run]
       )}
    end
  end

  defp get_entities(dsl_state) do
    Map.get(dsl_state, [:root]) |> Map.get(:entities)
  end
end
