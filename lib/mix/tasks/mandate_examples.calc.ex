defmodule Mix.Tasks.MandateExamples.Calc do
  use Mandate.Task, as: :mix

  # shortdoc "Generates a new Mix Task"
  # longdoc "Generates a new Mix Task, accepts arguments"
  # example "mix mandate_examples.calc new --num 13.37 --pin 42 -p 13"

  argument :expression do
    required true
  end

  switch :format, :string

  switch :precision, :integer do
    short :p
  end

  run fn args, _ ->
    Mix.shell().info("Running `mandate_examples.calc` with: #{inspect(args)}")
  end
end
