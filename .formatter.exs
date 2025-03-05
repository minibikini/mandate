# Used by "mix format"
spark_locals_without_parens = [
  argument: 1,
  argument: 2,
  argument: 3,
  default: 1,
  doc: 1,
  example: 1,
  keep: 1,
  longdoc: 1,
  required: 1,
  run: 1,
  short: 1,
  shortdoc: 1,
  switch: 1,
  switch: 2,
  switch: 3,
  type: 1
]

[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Spark.Formatter],
  locals_without_parens: spark_locals_without_parens
  # export: [
  #   locals_without_parens: spark_locals_without_parens
  # ]
]
