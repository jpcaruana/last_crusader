defmodule LastCrusader.Utils.Http do
  @moduledoc """
  Utils for easy HTTP manipulation
  """
  import Plug.Conn

  @doc """
  Add key-value header(s) to HTTP response
  """
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
end
