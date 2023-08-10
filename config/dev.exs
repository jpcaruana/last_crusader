import Config

config :tesla, adapter: Tesla.Mock

config :logger, :console,
  level: :critical,
  always_evaluate_messages: true
