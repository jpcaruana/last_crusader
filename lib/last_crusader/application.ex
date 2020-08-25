defmodule LastCrusader.Application do
  @moduledoc false
  import Supervisor.Spec

  use Application

  @doc false
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Use Plug.Cowboy.child_spec/3 to register our endpoint as a plug
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: LastCrusader.Router,
        # Set the port per environment, see ./config/MIX_ENV.exs
        options: [
          port: Application.get_env(:last_crusader, :port)
        ]
      ),
      supervisor(LastCrusader.Cache.Supervisor, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LastCrusader.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
