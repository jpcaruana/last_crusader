defmodule LastCrusader.Cache.Supervisor do
  @moduledoc false
  use Supervisor

  @doc false
  def start_link(_init_arg) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc false
  @impl true
  def init(_init_arg) do
    children = [
      %{
        id: LastCrusader.Cache.MemoryTokenStore,
        start: {LastCrusader.Cache.MemoryTokenStore, :start_link, [100]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
