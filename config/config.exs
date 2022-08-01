# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :last_crusader, env: config_env()

config :last_crusader,
  ecto_repos: [LastCrusader.Repo]

config :last_crusader, LastCrusader.Repo,
  adapter: Ecto.Adapters.SQLite3,
  # database: ":memory:"
  database: "db.sqlite3"

config :sentry,
  environment_name: :test

import_config "#{config_env()}.exs"

if config_env() != :prod do
  config :git_hooks,
    auto_install: false,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix format"}
        ]
      ],
      pre_push: [
        verbose: false,
        tasks: [
          {:cmd, "mix check"},
          {:cmd, "echo 'success!'"}
        ]
      ]
    ]
end
