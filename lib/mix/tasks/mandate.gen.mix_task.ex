defmodule Mix.Tasks.Mandate.Gen.MixTask do
  use Mandate, as: :mix_task

  shortdoc "Generates a new Mix Task"

  argument :name, :string do
    doc "Task name. Example: `my_app.my_task`"
    required true
  end

  run fn args ->
    IO.puts("Running my_task  with: #{inspect(args)}")
  end
end
