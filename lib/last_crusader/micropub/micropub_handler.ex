defmodule LastCrusader.Micropub.MicropubHandler do
  @moduledoc false
  import Plug.Conn

  def publish(conn) do
    h = conn.body_params["h"]
    content = conn.body_params["content"]

    conn
    |> send_resp(201, "Location: http://example.com/venue/10")
  end
end
