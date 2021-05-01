# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

import_config "#{Mix.env()}.exs"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  colors: [error: [:bright, :light_red]]

config :elixir, :time_zone_database, Tz.TimeZoneDatabase
config :last_crusader, env: Mix.env()

if Mix.env() != :prod do
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
