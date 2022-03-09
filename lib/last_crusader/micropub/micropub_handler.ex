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
  alias Jason, as: Json

  @doc """
  Handles query requests

  Note: we just reply to the "config", "syndicate-to" and "category" requests
  """
  def query(conn) do
    case conn.params["q"] do
      "config" ->
        conn |> json_reply(Application.get_env(:last_crusader, :micropub_config))

      "syndicate-to" ->
        syndicate_to =
          Map.get(Application.get_env(:last_crusader, :micropub_config), :"syndicate-to")

        conn |> json_reply(%{"syndicate-to": syndicate_to})

      "category" ->
        me = Application.get_env(:last_crusader, :me)

        with {:ok, %Tesla.Env{body: body, status: 200}} <- Tesla.get(me <> "tags/index.json"),
             {:ok, json_body} <- Json.decode(body),
             {:ok, categories} <- Map.fetch(json_body, "tags") do
          ordered_by_weight =
            categories
            |> Enum.flat_map(&Enum.to_list/1)
            |> Enum.sort_by(&elem(&1, 1))
            |> Enum.map(&elem(&1, 0))
            |> Enum.reverse()

          conn |> json_reply(%{categories: ordered_by_weight})
        else
          _ ->
            conn |> send_resp(404, "Not found")
        end

      _ ->
        conn |> send_resp(404, "Not found")
    end
  end

  @doc """
  Handles micropublish demands from HTTP
  """
  def publish(conn) do
    conn_headers = as_map(conn.req_headers)

    case Micropub.publish(conn_headers, conn.params) do
      {:ok, content_url} ->
        Logger.info("Content will be published here: #{inspect(content_url)}")

        conn
        |> put_headers(%{location: content_url})
        |> send_resp(202, "Accepted")

      {:error, :bad_token} ->
        Logger.error("bad auth token")

        conn
        |> send_resp(401, "bad auth token")

      other_error ->
        Logger.error("bad request: #{inspect(other_error)}")

        conn
        |> send_resp(400, "bad request")
    end
  end

  @doc """
  Handles comment posts from HTTP
  """
  def comment(conn) do
    case Micropub.comment(as_map(conn.params), DateTime.now!("Europe/Paris")) do
      {:ok, content_url} ->
        Logger.info("Content will be published here: #{inspect(content_url)}")

        conn
        |> put_headers(%{location: content_url})
        |> send_resp(202, "Accepted")

      {:error, :bad_token} ->
        Logger.error("bad auth token")

        conn
        |> send_resp(401, "bad auth token")

      other_error ->
        Logger.error("bad request: #{inspect(other_error)}")

        conn
        |> send_resp(400, "bad request")
    end
  end

  defp json_reply(conn, map) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Json.encode!(map))
  end
end
