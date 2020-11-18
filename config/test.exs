use Mix.Config

config :last_crusader,
  plug_logger: false,
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
  port: 4002
