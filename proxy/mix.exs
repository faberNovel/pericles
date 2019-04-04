defmodule PericlesProxy.MixProject do
  use Mix.Project

  def project do
    [
      app: :pericles_proxy,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PericlesProxy, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.4"},
      {:plug, "~> 1.6"},
      {:httpoison, "~> 1.2"},
      {:ecto, "~> 2.2"},
      {:postgrex, "~> 0.13.5"},
      {:poison, "~> 3.1"},
      {:rollbax, "~> 0.9.2"},
      {:new_relic_agent, "~> 1.0"},
      {:exvcr, "~> 0.10", only: :test}
    ]
  end
end
