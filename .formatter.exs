# Used by "mix format"
spark_locals_without_parens = [
  argument: 2,
  argument: 3,
  default: 1,
  description: 1,
  description: 2,
  doc: 1,
  example: 1,
  keep: 1,
  longdoc: 1,
  longdoc: 2,
  required: 1,
  run: 1,
  run: 2,
  short: 1,
  shortdoc: 1,
  shortdoc: 2,
  switch: 2,
  switch: 3
]

[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Spark.Formatter],
  locals_without_parens: spark_locals_without_parens
  # export: [
  #   locals_without_parens: spark_locals_without_parens
  # ]
]
