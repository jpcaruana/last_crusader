defmodule LastCrusader.Application do
  @moduledoc false
  use Application
  require Logger

  @doc false
  def start(_type, _args) do
    # List all child processes to be supervised
    children =
      [
        # Use Plug.Cowboy.child_spec/3 to register our endpoint as a plug
        Plug.Cowboy.child_spec(
          scheme: :http,
          plug: LastCrusader.Router,
          # Set the port per environment, see ./config/MIX_ENV.exs
          options: [
            port: Application.get_env(:last_crusader, :port)
          ]
        ),
        LastCrusader.Cache.Supervisor
      ]
      |> append_if(
        Application.get_env(:last_crusader, :env) != :test,
        {Tz.UpdatePeriodically, []}
      )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LastCrusader.Supervisor]
    started = Supervisor.start_link(children, opts)

    {:ok, version} = :application.get_key(:last_crusader, :vsn)
    Logger.info("Application LastCrusader #{version}: started")

    started
  end

  defp append_if(list, condition, item) do
    if condition, do: list ++ [item], else: list
  end
end
