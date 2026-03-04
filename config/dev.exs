import Config

config :tesla, adapter: Tesla.Mock

config :last_crusader, LastCrusader.Repo, database: "last_crusader_dev.db"
config :last_crusader, port: 4000

config :logger, :console,
  level: :critical,
  always_evaluate_messages: true

config :sentry,
  environment_name: :dev
