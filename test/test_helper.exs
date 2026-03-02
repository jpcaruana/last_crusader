ExUnit.start()

defmodule LastCrusader.TestHelpers do
  @moduledoc false
  alias LastCrusader.Cache.MemoryTokenStore

  def wait_for_deletion(key, timeout_ms \\ 100) do
    start_time = System.monotonic_time(:millisecond)

    Stream.repeatedly(fn ->
      case MemoryTokenStore.read(key) do
        :not_found -> :deleted
        _ -> :not_deleted
      end
    end)
    |> Stream.take_while(fn
      :deleted ->
        false

      :not_deleted ->
        elapsed = System.monotonic_time(:millisecond) - start_time
        elapsed < timeout_ms
    end)
    |> Enum.to_list()
  end
end
