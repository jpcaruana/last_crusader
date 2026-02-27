# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :elixir, :time_zone_database, Tz.TimeZoneDatabase
config :last_crusader, env: config_env()

config :sentry,
  environment_name: :test

# GitLab backend (set :git_backend to LastCrusader.Micropub.GitLab to use)
# config :last_crusader,
#   gitlab_host: "https://gitlab.com",
#   gitlab_token: "glpat-...",
#   gitlab_project_id: "namespace%2Frepo",
#   gitlab_branch: "main"

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
