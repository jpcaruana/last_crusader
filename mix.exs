defmodule LastCrusader.MixProject do
  use Mix.Project

  def project do
    [
      app: :last_crusader,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :poison],
      mod: {LastCrusader.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"}, # This will pull in Plug AND Cowboy
      {:poison, "~> 3.1"} # Latest version as of this writing
    ]
  end
end
