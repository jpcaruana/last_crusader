defmodule LastCrusader.Auth do
  @moduledoc """
  Handles HTTP requests for IndieAuth

  see https://indieweb.org/authorization-endpoint
  """
  import Plug.Conn

  def auth(conn) do
    q = fetch_query_params(conn)
    redirect_uri = q.query_params["redirect_uri"]
    state = q.query_params["state"]

    conn = put_headers(conn, %{location: "#{redirect_uri}?code=xxxxxxxx&state=#{state}"})

    send_resp(conn, 301, "")
  end

  defp put_headers(conn, key_values) do
    Enum.reduce key_values, conn, fn {k, v}, conn ->
      put_resp_header(conn, to_string(k), v)
    end
  end
end
