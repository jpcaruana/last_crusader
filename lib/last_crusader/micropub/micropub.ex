defmodule LastCrusader.Micropub do
  @moduledoc """
  Handles the _logic_ of micro-publishing.

  Does not worry about HTTP
  """

  import LastCrusader.Utils.Http

  alias LastCrusader.Micropub.PostTypeDiscovery, as: PostTypeDiscovery
  alias LastCrusader.Micropub.Hugo, as: Hugo
  alias LastCrusader.Micropub.GitHub, as: GitHub
  alias LastCrusader.Webmentions, as: Webmentions
  alias Poison, as: Json

  @doc """
  Publishes as Hugo post to Github repo:

  - checks auth code and scope
  - discovers post type
  - transforms it as a Hugo post
  - commits to Github repo
  - schedules sending webmentions if needed
  """
  def publish(headers, params) do
    me = Application.get_env(:last_crusader, :me)

    with {:ok, :valid} <-
           check_auth_code(
             headers[:authorization],
             me,
             Application.get_env(:last_crusader, :micropub_issuer),
             "create"
           ),
         {filename, filecontent, path} <-
           PostTypeDiscovery.discover(as_map(params))
           |> Hugo.new(DateTime.now!("Europe/Paris"), params),
         mentionned_links <- Hugo.extract_links(filecontent),
         {:ok, :content_created} <-
           GitHub.new_file(
             Application.get_env(:last_crusader, :github_auth),
             Application.get_env(:last_crusader, :github_user),
             Application.get_env(:last_crusader, :github_repo),
             filename,
             filecontent,
             Application.get_env(:last_crusader, :github_branch, "master")
           ),
         content_url <- generate_published_url(me, path),
         {:ok, _} <-
           Webmentions.Sender.schedule_webmentions(
             mentionned_links,
             content_url,
             Application.get_env(:last_crusader, :webmention_delai_ms, 900_000)
           ) do
      {:ok, content_url}
    else
      error -> error
    end
  end

  defp check_auth_code(auth_header, me, issuer, scope) do
    %{body: body, status: status} =
      Tesla.get!(
        issuer,
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

  defp generate_published_url(host, path) do
    host <> path
  end
end
