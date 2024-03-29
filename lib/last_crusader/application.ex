defmodule LastCrusader.Application do
  @moduledoc false
  use Application
  require Logger

  @doc false
  def start(_type, _args) do
    # List all child processes to be supervised
    children =
      [
        {
          Bandit,
          plug: LastCrusader.Router,
          scheme: :http,
          thousand_island_options: [port: Application.get_env(:last_crusader, :port)]
        },
        LastCrusader.Cache.Supervisor,
        {
          Task.Supervisor,
          name: LastCrusader.TaskSupervisor
        }
      ]
      |> append_if(
        Application.get_env(:last_crusader, :env) != :test &&
          Application.get_env(:last_crusader, :env) != :dev,
        {Tz.UpdatePeriodically, []}
      )

    opts = [strategy: :one_for_one, name: LastCrusader.Supervisor]
    started = Supervisor.start_link(children, opts)

    {:ok, version} = :application.get_key(:last_crusader, :vsn)

    Logger.info(
      "Application LastCrusader #{version}: started on port #{Application.get_env(:last_crusader, :port)}"
    )

    started
  end

  defp append_if(list, condition, item) do
    if condition, do: list ++ [item], else: list
  end
end
