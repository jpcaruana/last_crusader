use Mix.Config

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
        %{type: "note", name: "Note"},
        %{type: "article", name: "Blog Article"},
        %{type: "bookmark", name: "Bookmark"}
      ]
    },
    "syndicate-to": [
      %{
        uid: "https://twitter.com/somme_twitter_account",
        name: "Twitter"
      }
    ]
  },
  # 15 minutes
  webmention_delai_ms: 900_000,
  port: 8080

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
