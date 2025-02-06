defmodule Lume.MixProject do
  use Mix.Project

  @version "0.2.0"
  @source_url "https://github.com/abradburne/lume"

  def project do
    [
      app: :lume,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A Phoenix UI component library",
      homepage_url: "https://lumeui.dev",
      package: package(),
      source_url: @source_url,
      elixirc_paths: elixirc_paths(Mix.env()),
      files: ~w(lib mix.exs README.md LICENSE),
      docs: [
        main: "Lume",
        extras: ["README.md"]
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2", only: :test},
      {:floki, ">= 0.30.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "lume",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Documentation" => "https://hexdocs.pm/lume"
      },
      maintainers: ["Alan Bradburne"],
      files: ~w(lib mix.exs README.md CHANGELOG.md LICENSE.md .formatter.exs)
    ]
  end
end
