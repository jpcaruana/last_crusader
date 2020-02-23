defmodule LastCrusader.Application do
  @moduledoc """
  Documentation for `LastCrusader`.
  """

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: LastCrusader.Worker.start_link(arg)
      # {LastCrusader.Worker, arg},
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: LastCrusader.Router,
        options: [
          port: 8085
        ]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LastCrusader.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
