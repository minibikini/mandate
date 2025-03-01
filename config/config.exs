if Mix.env() == :dev do
  import Config
  config :spark, formatter: [remove_parens?: true]
end
