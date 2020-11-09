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

  alias LastCrusader.Micropub.PostTypeDiscovery, as: PostTypeDiscovery
  alias LastCrusader.Micropub.Hugo, as: Hugo
  alias LastCrusader.Micropub.GitHub, as: GitHub
  alias Poison, as: Json

  def publish(conn) do
    conn_headers = as_map(conn.req_headers)
    me = "https://jp.caruana.fr/"

    with {:ok, _} <-
           check_auth_code(
             conn_headers[:authorization],
             me,
             "https://tokens.indieauth.com/token",
             "create"
           ),
         {filename, filecontent, path} <-
           PostTypeDiscovery.discover(as_map(conn.params))
           |> Hugo.new(Timex.local(), conn.params),
         {:ok, _} <-
           GitHub.new_file(
             %{access_token: "THIS IS A SECRET"},
             "jpcaruana",
             "jp.caruana.fr",
             "new " <> filename,
             filename,
             filecontent,
             "master"
           ) do
      conn
      |> put_headers(%{location: me <> path})
      |> send_resp(202, "")
    else
      {:error, :bad_token} ->
        conn
        |> send_resp(401, "bad auth token")

      _ ->
        conn
        |> send_resp(400, "bad request")
    end
  end

  defp check_auth_code(auth_header, me, issuer, scope) do
    %{body: body, status: status} =
      Tesla.get!(
        "https://tokens.indieauth.com/token",
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
    scope in full_scope
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
end
