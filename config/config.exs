# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

import_config "#{Mix.env()}.exs"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  colors: [error: [:bright, :light_red]]

config :elixir, :time_zone_database, Tz.TimeZoneDatabase
config :last_crusader, env: Mix.env()

config :last_crusader,
  me: "https://some.url.fr/",
  micropub_issuer: "https://some.issuer.com/token",
  github_user: "some_uer",
  github_repo: "some_repo",
  github_branch: "master",
  github_auth: %{
    access_token: "THIS IS A SECRET"
  },
  micropub_config: %{
    types: %{
      "post-types": [
        %{type: "note", name: "Note"}
      ]
    },
    "syndicate-to": [
      %{
        uid: "https://twitter.com/some_twitter_account",
        name: "Twitter"
      }
    ]
  },
  webmention_nb_tries: 15,
  port: 4001

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
