defmodule Mix.Tasks.Mandate.Gen.MixTask do
  use Mandate, as: :mix_task
  # use Mandate

  shortdoc "Generates a new Mix Task"

  argument :name, :string do
    required true
  end

  switch :input_file, :string

  switch :input_file, :string,
    short: "-i",
    required: true,
    doc: "Input file path"

  switch :output_dir, :string, default: "./output", doc: "Output directory"

  switch :verbose, :boolean, short: "-v", doc: "Enable verbose output"

  # run fn args ->
  #   IO.puts("Running my_task (macro version) with:")
  #   IO.inspect(args)
  #   # Task logic
  # end

  # run(fn args, parsed_options ->
  #   IO.puts("Running my_task (macro version) with:")
  #   IO.inspect(parsed_options)
  #   # Task logic
  # end)
end
