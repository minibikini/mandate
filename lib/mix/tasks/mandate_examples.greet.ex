defmodule Mix.Tasks.MandateExamples.Greet do
  use Mandate.Task, as: :mix

  # shortdoc "Generates a new Mix Task"
  # longdoc "Generates a new Mix Task, accepts arguments"
  # example "mix mandate_examples.greet new --num 13.37 --pin 42 -p 13"

  argument :name do
    required true
  end

  switch :verbose do
    short :v
  end

  run fn args, _ ->
    Mix.shell().info("Running `mandate_examples.greet` with: #{inspect(args)}")
  end
end
