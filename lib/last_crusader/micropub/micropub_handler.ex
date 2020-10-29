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
  alias Poison, as: Json

  def publish(conn) do
    # - [ ] verify access token
    # - [X] discover post type
    # - [X] transform to hugo
    #   - [X] name the file
    # - [X] post to github
    # - [X] http reply to client
    Logger.info("------------------------")
    Logger.info(conn.req_headers)
    Logger.info(conn.params)
    Logger.info("------------------------")

    post_type = PostTypeDiscovery.discover(
      conn.params
      |> Enum.map(fn {a, b} -> {String.to_atom(a), b} end)
      |> Map.new
    )

    {filename, filecontent, path} =
      Hugo.new(
        post_type,
        Timex.local(),
        "name_" <> Integer.to_string(Enum.random(10..100_000)),
        conn.params
      )

    GitHub.new_file(
      %{access_token: "secret bien gardé"},
      "jpcaruana",
      "jp.caruana.fr",
      "new " <> filename,
      filename,
      filecontent,
      "test_micropub"
    )

    {status, body, headers} =
      {202, "", %{location: "https://test-micropub--jp-caruana-fr.netlify.app/" <> path}}

    conn
    |> put_headers(headers)
    |> send_resp(status, body)
  end

end
