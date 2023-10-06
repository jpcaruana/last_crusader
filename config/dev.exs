import Config

config :tesla, adapter: Tesla.Mock

config :logger, :console,
  level: :critical,
  always_evaluate_messages: true

config :sentry,
  environment_name: :dev
