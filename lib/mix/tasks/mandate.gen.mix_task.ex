defmodule Mix.Tasks.Mandate.Gen.MixTask do
  use Mandate, as: :mix_task

  shortdoc "Generates a new Mix Task"
  longdoc "Generates a new Mix Task, accepts arguments"

  argument :name, :string do
    doc "Task name. Example: `my_app.my_task`"
    required true
  end

  argument :my_number, :integer do
    doc "Any number"
    example 42
  end

  run fn args ->
    name = Mix.Task.task_name(__MODULE__)
    Mix.shell().info("Running `#{name}` with: #{inspect(args)}")
  end
end
