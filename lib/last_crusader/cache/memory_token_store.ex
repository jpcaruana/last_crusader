defmodule LastCrusader.Cache.MemoryTokenStore do
  @moduledoc """
    Simple ETS-based cache.

    https://gist.github.com/raorao/a4bb34726af2e3fa071adfa504505e1d
  """
  use GenServer

  @type t :: %{ttl: integer, invalidators: %{}}
  @type cache_key :: any
  @type cache_value :: any

  @doc """
    Starts a RequestCache process linked to the current process. See
    `GenServer.start_link/2` for details.

    By default, every item in the cache lives for 6 hours.
  """
  @spec start_link(integer) :: GenServer.on_start
  def start_link(ttl_seconds \\ 21_600) do
    GenServer.start_link(__MODULE__, ttl_seconds, name: __MODULE__)
  end

  @doc """
    Asynchronous call to cache a value at the provided key. Any key that can
    be used with ETS can be used, and will be evaluated using `==`.
  """
  @spec cache(cache_key, cache_value) :: :ok
  def cache(key, val) do
    GenServer.cast(__MODULE__, {:cache, key, val})
  end

  @doc """
    Asynchronous clears all values in the cache.
  """
  @spec clear() :: :ok
  def clear do
    GenServer.cast(__MODULE__, :clear)
  end

  @doc """
    Sychronously reads the cache for the provided key. If no value is found,
    returns :not_found .
  """
  @spec read(cache_key) :: cache_value | :not_found
  def read(key) do
    case :ets.lookup(:request_cache, key) do
      [{^key, value} | _rest] -> value
      [] -> :not_found
    end
  end

  @doc """
    Sychronously reads the cache for the provided key. If no value is found,
    invokes default_fn and caches the result. Note: in order to prevent congestion
    of the RequestCache process, default_fn is invoked in the context of the caller
    process.
  """
  @spec read_or_cache_default(cache_key, (() -> cache_value)) :: cache_value
  def read_or_cache_default(key, default_fn) do
    case read(key) do
      :not_found ->
        value = default_fn.()
        cache key, value
        value
      value ->
        value
    end
  end

  # GenServer Callbacks

  @spec init(integer) :: {:ok, t}
  def init(ttl_seconds) do
    initial_state = %{invalidators: %{}, ttl: ttl_seconds * 1_000}
    generate_table()
    {:ok, initial_state}
  end

  @spec handle_cast({:cache, cache_key, cache_value}, t) :: {:noreply, t}
  def handle_cast({:cache, key, val}, state = %{ttl: ttl, invalidators: invalidators}) do
    # since we're updating the value, let's kill off the last invalidator.
    case Map.get(invalidators, key) do
      nil -> nil
      invalidator -> Process.cancel_timer(invalidator)
    end

    # insert the value into the table
    :ets.insert(:request_cache, {key, val})

    # generate a new invalidator
    invalidator = Process.send_after(self(), {:invalidate, key}, ttl)

    # and store it.
    {:noreply, %{state | invalidators: Map.put(invalidators, key, invalidator)}}
  end

  @spec handle_cast(:clear, t) :: {:noreply, t}
  def handle_cast(:clear, state = %{invalidators: invalidators}) do
    invalidators
    |> Map.keys
    |> Enum.each(&Process.cancel_timer/1)

    :ets.delete(:request_cache)
    generate_table()
    {:noreply, %{state | invalidators: %{}}}
  end

  @spec handle_info({:invalidate, cache_key}, t) :: {:noreply, t}
  def handle_info({:invalidate, key}, state) do
    :ets.delete(:request_cache, key)
    {:noreply, state}
  end

  defp generate_table do
    :ets.new(:request_cache, [:set, :protected, :named_table])
  end
end
