defmodule Mix.Tasks.Mandate.Gen.MixTask do
  use Mandate, as: :mix_task

  shortdoc "Generates a new Mix Task"
  longdoc "Generates a new Mix Task, accepts arguments"

  argument :name do
    doc "Task name. Example: `my_app.my_task`"
    required true
  end

  argument :my_number, :float do
    doc "Any number"
    example 42.42
  end

  switch :help, short: :h

  switch :pin, :integer do
    short :p
  end

  run fn options ->
    name = Mix.Task.task_name(__MODULE__)
    Mix.shell().info("Running `#{name}` with: #{inspect(options)}")
  end
end
