defmodule Cache.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(RequestCache, [[name: RequestCache]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
