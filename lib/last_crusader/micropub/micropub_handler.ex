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

  def publish(conn) do
    # - [X] verify access token
    # - [X] discover post type
    # - [X] transform to hugo
    #   - [X] name the file
    # - [X] post to github
    # - [X] http reply to client

    conn_headers = as_map(conn.req_headers)
    me = "https://jp.caruana.fr/"

    with {:ok, _} <-
           check_auth_code(
             conn_headers[:authorization],
             me,
             "https://tokens.indieauth.com/token",
             "TODO check scope?"
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
      {status, body, headers} = {202, "", %{location: me <> path}}

      conn
      |> put_headers(headers)
      |> send_resp(status, body)
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

    with {200, b} <- {status, body},
         {me, issuer} <- decode(b) do
      {:ok, :valid}
    else
      _ ->
        {:error, :bad_token}
    end
  end

  defp decode(json) do
    decoded_body = Poison.decode!(json)
    {decoded_body["me"], decoded_body["issued_by"]}
  end

  defp as_map(list_of_tuples) do
    list_of_tuples
    |> Enum.map(fn {a, b} -> {String.to_atom(a), b} end)
    |> Map.new()
  end
end
