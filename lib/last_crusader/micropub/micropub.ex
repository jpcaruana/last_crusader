defmodule LastCrusader.Micropub do
  @moduledoc """
  Handles the _logic_ of micro-publishing.

  See also:
  - `LastCrusader.Micropub.Hugo`
  - `LastCrusader.Micropub.Github`
  """

  import LastCrusader.Utils.Http

  alias LastCrusader.Micropub.PostTypeDiscovery, as: PostTypeDiscovery
  alias LastCrusader.Micropub.Hugo, as: Hugo
  alias LastCrusader.Utils.Toml, as: Toml
  alias LastCrusader.Micropub.GitHub, as: GitHub
  alias LastCrusader.Webmentions, as: Webmentions
  alias Jason, as: Json

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
         mentioned_links <- Hugo.extract_links(filecontent),
         {:ok, :content_created} <- GitHub.new_file(filename, filecontent),
         content_url <- generate_published_url(me, path),
         {:ok, _} <-
           Webmentions.Sender.schedule_webmentions(
             mentioned_links,
             content_url,
             Application.get_env(:last_crusader, :webmention_nb_tries, 15)
           ) do
      {:ok, content_url}
    else
      error -> error
    end
  end

  @doc """
  Adds a comment to a post into Github repo.
  It checks that the commented page exists in the Github repo (not on the real website).

  To make it work in Hugo, you have to publish your content as
  [Pages Bundles](https://gohugo.io/content-management/page-bundles/).
  In your post template, include the following partial:

      {{ partial "comments.html" . }}

  The Hugo partial ("comments.html") to display comments looks like this:

      {{ $comments := (.Resources.Match "comments/*yml") }}

      {{ range $comments }}
      <li>
        <i class="fas fa-reply"></i>
      {{ $comment := (.Content | transform.Unmarshal) }}
        <a href="{{ $comment.link }}">{{ $comment.author }}</a> le {{ substr $comment.date 0 10 }} :
        {{ $comment.comment | markdownify }}
      </li>
      {{ end }}
  """
  def comment(params, now) do
    filename =
      Hugo.reverse_url_root(params.original_page, Application.get_env(:last_crusader, :me))

    comment_author = params.author
    comment_content = params.comment
    comment_date = Hugo.convert_date_to_hugo_format(now)
    # not mandatory, can be nil
    comment_link = params[:link]

    comment_yml_template = """
    date: <%= date %>
    author: <%= author %>
    <%= if link != nil do %>link: <%= link %><% end %>
    comment: |
      <%= content %>
    """

    case GitHub.get_file(filename) do
      {:ok, _page_exists} ->
        comment_filename =
          filename <> "/comments/" <> Integer.to_string(DateTime.to_unix(now, :second)) <> ".yml"

        comment_filecontent =
          EEx.eval_string(comment_yml_template,
            date: comment_date,
            author: comment_author,
            link: comment_link,
            content: comment_content
          )

        {GitHub.new_file(comment_filename, comment_filecontent), comment_filecontent}

      error ->
        error
    end
  end

  @doc """
  Adds a keyword to a published post (most of the time, it will be the syndication link).
  """
  def add_keyword_to_post(published_page_url, {newkey, value}) do
    host = Application.get_env(:last_crusader, :me)
    filename = Hugo.reverse_url(published_page_url, host)

    with {:ok, filecontent} <- GitHub.get_file(filename),
         {frontmatter, markdown} <- Toml.extract_frontmatter_and_content(filecontent),
         new_frontmatter <- Toml.update_toml(frontmatter, {newkey, value}),
         {:ok, :content_updated} <- GitHub.update_file(filename, new_frontmatter <> markdown) do
      {:ok, published_page_url}
    else
      error -> error
    end
  end

  defp check_auth_code(auth_header, me, issuer, scope) do
    with %{body: body, status: 200} <-
           Tesla.get!(issuer,
             headers: [
               Authorization: auth_header,
               accept: "application/json"
             ]
           ),
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
    {:ok, decoded_body} = Json.decode(json)
    {decoded_body["me"], decoded_body["issued_by"], decoded_body["scope"]}
  end

  defp generate_published_url(host, path) do
    host <> path
  end
end
