defmodule LastCrusader.Micropub.MicropubHandler do
  @moduledoc """
  The Micropub protocol is used to create, update and delete posts on one's own domain using third-party clients. Web apps and native apps (e.g., iPhone, Android) can use Micropub to post and edit articles, short notes, comments, likes, photos, events or other kinds of posts on your own website.

    cf spec: https://micropub.spec.indieweb.org/

    cf https://indieweb.org/post-type-discovery for Post Type discovery
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
