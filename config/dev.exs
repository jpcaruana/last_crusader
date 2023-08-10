import Config

config :tesla, adapter: Tesla.Mock

config :logger,
  level: :critical,
  always_evaluate_messages: true
