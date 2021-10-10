defmodule AliasMethod.MixProject do
  use Mix.Project

  def project do
    [
      app: :alias_method,
      version: "0.1.0",
      elixir: "~> 1.12",
      name: "Alias Method",
      description: "Implementation of Walker's Alias method by Elixir",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
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
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:earmark, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["thara"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/thara/elixir_alias_method"}
    ]
  end
end
