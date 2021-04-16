use Mix.Config

config :last_crusader,
  plug_logger: false,
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
  webmention_nb_tries: 15,
  port: 4002

config :tesla, adapter: Tesla.Mock
