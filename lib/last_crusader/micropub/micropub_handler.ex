defmodule LastCrusader.Micropub.MicropubHandler do
  @moduledoc """
  The Micropub protocol is used to create, update and delete posts on one's own domain using third-party clients. Web apps and native apps (e.g., iPhone, Android) can use Micropub to post and edit articles, short notes, comments, likes, photos, events or other kinds of posts on your own website.

    cf spec: https://micropub.spec.indieweb.org/

    cf https://indieweb.org/post-type-discovery for Post Type discovery
  """
  import Plug.Conn
  import LastCrusader.Utils.Http

  alias Poison, as: Json

  def publish(conn) do
    type = conn.params["h"]
    _content = conn.params["content"]

    # - [X] discover post type
    # - [ ] transform to hugo
    # - [ ] post to github
    # - [ ] http reply to client

    {status, body, headers} =
      case type do
        "entry" -> {202, "", %{location: "http://example.com/venue/10"}}
        _ -> {400, Json.encode!(%{error: "invalid_request"}), nil}
      end

    conn
    |> put_headers(headers)
    |> send_resp(status, body)
  end
end
