defmodule LastCrusader.Micropub.MicropubHandler do
  @moduledoc """
    cf spec: https://micropub.spec.indieweb.org/
  """
  import Plug.Conn

  def publish(conn) do
    h = conn.body_params["h"]
    content = conn.body_params["content"]

    {code, content} =
      case h do
        "entry" -> {201, "Location: http://example.com/venue/10"}
        _ -> {400, "bad request"}
      end

    conn
    |> send_resp(code, content)
  end
end
