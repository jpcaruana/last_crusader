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

  alias LastCrusader.Micropub.PostTypeDiscovery, as: PostTypeDiscovery
  alias LastCrusader.Micropub.Hugo, as: Hugo
  alias LastCrusader.Micropub.GitHub, as: GitHub
  alias LastCrusader.Webmentions, as: Webmentions
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
    me = Application.get_env(:last_crusader, :me)

    with {:ok, _} <-
           check_auth_code(
             conn_headers[:authorization],
             me,
             Application.get_env(:last_crusader, :micropub_issuer),
             "create"
           ),
         {filename, filecontent, path} <-
           PostTypeDiscovery.discover(as_map(conn.params))
           |> Hugo.new(Timex.local(), conn.params),
         mentionned_links <- Hugo.extract_links(filecontent),
         {:ok, _} <-
           GitHub.new_file(
             Application.get_env(:last_crusader, :github_auth),
             Application.get_env(:last_crusader, :github_user),
             Application.get_env(:last_crusader, :github_repo),
             "new " <> filename,
             filename,
             filecontent,
             Application.get_env(:last_crusader, :github_branch, "master")
           ),
         content_url <- generate_puslished_url(me, path),
         {:ok} <-
           Webmentions.Sender.schedule_webmentions(
             mentionned_links,
             content_url,
             Application.get_env(:last_crusader, :webmention_delai_ms, 900_000)
           ) do
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

  defp check_auth_code(auth_header, me, issuer, scope) do
    %{body: body, status: status} =
      Tesla.get!(
        Application.get_env(:last_crusader, :micropub_issuer),
        headers: [
          Authorization: auth_header,
          accept: "application/json"
        ]
      )

    with {200, body} <- {status, body},
         {^me, ^issuer, full_scope} <- decode(body),
         true <- check_scope(scope, full_scope) do
      {:ok, :valid}
    else
      _ ->
        {:error, :bad_token}
    end
  end

  defp check_scope(scope, full_scope) do
    scope in String.split(full_scope)
  end

  defp decode(json) do
    decoded_body = Json.decode!(json)
    {decoded_body["me"], decoded_body["issued_by"], decoded_body["scope"]}
  end

  defp as_map(list_of_tuples) do
    list_of_tuples
    |> Enum.map(fn {a, b} -> {String.to_atom(a), b} end)
    |> Map.new()
  end

  defp generate_puslished_url(host, path) do
    host <> path
  end
end
