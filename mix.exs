defmodule LastCrusader.MixProject do
  use Mix.Project

  def project do
    [
      app: :last_crusader,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ],
      test_coverage: [tool: ExCoveralls],

      # Docs
      name: "Last Crusader",
      source_url: "https://github.com/jpcaruana/last_crusader",
      homepage_url: "https://github.com/jpcaruana/last_crusader",
      docs: [
        # The main page in the docs
        main: "readme",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
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
      # This will pull in Plug AND Cowboy
      {:plug_cowboy, "~> 2.0"},
      # Latest version as of this writing
      {:poison, "~> 4.0.1"},
      # microformats parser
      {:microformats2, "~> 0.6.0"},
      {:tesla, "~> 1.3.0"},
      # code coverage
      {:excoveralls, "~> 0.12.2", only: :test},
      # doc generation: mix docs
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end
