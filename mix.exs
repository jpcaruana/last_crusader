defmodule LastCrusader.MixProject do
  use Mix.Project

  def project do
    [
      app: :last_crusader,
      version: "0.11.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
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
      aliases: aliases(),

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
      extra_applications: [:logger, :jason],
      mod: {LastCrusader.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.13"},
      {:bandit, ">= 0.6.9"},
      {:jason, "~> 1.2"},
      {:tesla, "~> 1.7.0"},
      {:castore, "~> 1.0.3"},
      {:mint, "~> 1.0"},
      {:tz, "~> 0.26.1"},
      {:slugger, "~> 0.3"},
      {:remove_emoji, "~> 1.0.0"},
      {:webmentions, "~> 3.0.1"},
      # sentry
      {:sentry, "~> 10.0"},
      {:hackney, "~> 1.8"},
      # code coverage
      {:excoveralls, "~> 0.18.0", only: :test},
      # doc generation: mix docs
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:doctor, "~> 0.21.0", only: :dev},
      # watch for tests
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.15.0", only: [:dev], runtime: false},
      {:git_hooks, "~> 0.7.0", only: [:test, :dev], runtime: false},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      pkg: ["cmd ./build_container"],
      sentry_recompile: ["compile", "deps.compile sentry --force"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]
end
