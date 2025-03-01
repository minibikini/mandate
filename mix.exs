defmodule Mandate.MixProject do
  use Mix.Project

  def project do
    [
      name: "Mandate",
      description: description(),
      package: package(),
      app: :mandate,
      version: "0.1.0",
      elixir: "~> 1.18",
      source_url: "https://github.com/minibikini/mandate",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp description do
    "Build robust, elegant CLIs with minimal boilerplate"
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.37", only: :dev, runtime: false},
      {:igniter, "~> 0.5", only: [:dev, :test]},
      {:sourceror, "~> 1.7", only: [:dev, :test]},
      {:spark, "~> 2.2"}
    ]
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/minibikini/mandate"}
    ]
  end
end
