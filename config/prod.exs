import Config

config :logger, :console,
  level: :info,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :sentry,
  dsn: "https://xxx@o122392.ingest.sentry.io/12345",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_paths: [File.cwd!()],
  tags: %{
    env: "production"
  },
  included_environments: [:prod]
