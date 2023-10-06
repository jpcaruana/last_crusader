import Config

config :last_crusader,
  port: 4002

config :tesla, adapter: Tesla.Mock

config :logger, :console,
  level: :critical,
  always_evaluate_messages: true

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

config :sentry,
  environment_name: :test
