defmodule LastCrusader.Micropub.MicropubHandler do
  @moduledoc """
  The Micropub protocol is used to create, update and delete posts on one's own domain using third-party clients.

  Web apps and native apps (e.g., iPhone, Android) can use Micropub to post and edit articles, short notes, comments,
  likes, photos, events or other kinds of posts on your own website.

  cf full specification: https://micropub.spec.indieweb.org/

  see also `LastCrusader.Micropub.PostTypeDiscovery`.
  """
  import Plug.Conn
  import LastCrusader.Utils.Http
  require Logger

  alias LastCrusader.Micropub, as: Micropub
  alias Poison, as: Json

  def query(conn) do
    case conn.params["q"] do
      "config" ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Json.encode!(Application.get_env(:last_crusader, :micropub_config)))

      _ ->
        conn
        |> send_resp(404, "")
    end
  end

  def publish(conn) do
    conn_headers = as_map(conn.req_headers)

    with {:ok, content_url} <- Micropub.publish(conn_headers, conn.params) do
      Logger.info(
        "Content successfully published (with a build delay) to #{inspect(content_url)}"
      )

      conn
      |> put_headers(%{location: content_url})
      |> send_resp(202, "")
    else
      {:error, :bad_token} ->
        Logger.error("bad auth token")

        conn
        |> send_resp(401, "bad auth token")

      _ ->
        Logger.error("bad request")

        conn
        |> send_resp(400, "bad request")
    end
  end
end
