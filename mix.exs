defmodule LastCrusader.MixProject do
  use Mix.Project

  def project do
    [
      app: :last_crusader,
      version: "0.3.4",
      elixir: "~> 1.10",
      start_permanent: Mix.env() in [:prod, :perso],
      deps: deps(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ],
      test_coverage: [
        tool: ExCoveralls
      ],
      releases: [
        last_crusader: [
          include_executables_for: [:unix],
          include_erts: false
        ]
      ],

      # Docs
      name: "Last Crusader",
      source_url: "https://github.com/jpcaruana/last_crusader",
      homepage_url: "https://github.com/jpcaruana/last_crusader",
      docs: [
        # The main page in the docs
        main: "readme",
        # logo: "path/to/logo.png",
        extras: ["README.md", "CHANGELOG.md", "CONTRIBUTING.md", "LICENSE"]
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
      {:plug_cowboy, "~> 2.4.1"},
      {:poison, "~> 4.0.1"},
      {:tesla, "~> 1.4.0"},
      {:tz, "~> 0.12.0"},
      {:toml, "~> 0.6.1"},
      {:slugger, "~> 0.3"},
      {:remove_emoji, "~> 1.0.0"},
      {:webmentions, "~> 0.5.2"},
      # code coverage
      {:excoveralls, "~> 0.14.0", only: :test},
      # doc generation: mix docs
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:doctor, "~> 0.17.0", only: :dev},
      # watch for tests
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.14.0", only: [:dev], runtime: false},
      {:git_hooks, "~> 0.5.2", only: [:test, :dev], runtime: false}
    ]
  end
end
