defmodule LastCrusader.Cache.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(LastCrusader.Cache.MemoryTokenStore, [100])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
