defmodule Mandate do
  @moduledoc """
  Documentation for `Mandate`.
  """

  use Spark.Dsl,
    default_extensions: [
      extensions: [Mandate.Dsl]
    ]

  def handle_before_compile(_opts) do
    quote do
      def main(argv) do
        Spark.Dsl.Extension.get_entities(__MODULE__, [:commands])
        |> Enum.map(fn cmd ->
          module =
            case cmd.impl do
              {mod, _opts} -> mod
              mod when is_atom(mod) and not is_nil(mod) -> mod
              nil -> cmd.module
            end

          if module && Spark.Dsl.is?(module, Mandate.Command) do
            Mandate.Command.Info.mod(module)

            state = Spark.Dsl.Extension.get_entities(module, [:mod])
            # IO.inspect({cmd.name, module, state})

            cmd
          else
            cmd
          end
        end)
      end
    end
  end
end
