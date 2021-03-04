defmodule LastCrusader.Utils.Http do
  @moduledoc """
  Utils for easy HTTP manipulation
  """
  import Plug.Conn

  @doc """
  Add key-value header(s) to HTTP response
  """
  @spec put_headers(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def put_headers(conn, key_values)
  def put_headers(conn, nil), do: conn

  def put_headers(conn, key_values) do
    Enum.reduce(
      key_values,
      conn,
      fn {k, v}, conn ->
        put_resp_header(conn, to_string(k), v)
      end
    )
  end

  @doc """
  Transforms a list of tuples into a Map
  """
  @spec as_map(list(tuple())) :: map()
  def as_map(list_of_tuples) do
    list_of_tuples
    |> Enum.map(fn {a, b} -> {String.to_atom(a), b} end)
    |> Map.new()
  end
end
