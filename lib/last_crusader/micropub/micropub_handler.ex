defmodule LastCrusader.Micropub.MicropubHandler do
  @moduledoc """
    cf spec: https://micropub.spec.indieweb.org/
  """
  import Plug.Conn
  import Poison

  def publish(conn) do
    type = conn.body_params["h"]
    content = conn.body_params["content"]

    {status, body, headers} =
      case type do
        "entry" -> {202, "", %{location: "http://example.com/venue/10"}}
        _ -> {400, encode!(%{error: "invalid_request"}), nil}
      end

    conn
    |> put_headers(headers)
    |> send_resp(status, body)
  end

  defp put_headers(conn, nil), do: conn

  defp put_headers(conn, key_values) do
    Enum.reduce(key_values, conn, fn {k, v}, conn ->
      put_resp_header(conn, to_string(k), v)
    end)
  end
end
