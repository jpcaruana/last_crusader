defmodule LastCrusader.Micropub do
  @moduledoc """
  Handles the _logic_ of micro-publishing.

  See also:
  - `LastCrusader.Micropub.Hugo`
  - `LastCrusader.Micropub.Backend`
  """
  alias LastCrusader.Micropub.PostTypeDiscovery, as: PostTypeDiscovery
  alias LastCrusader.Micropub.Hugo, as: Hugo
  alias LastCrusader.Utils.Toml, as: Toml
  alias LastCrusader.Webmentions, as: Webmentions
  alias LastCrusader.Utils.Http, as: Utils
  alias LastCrusader.Cache.MemoryTokenStore, as: TokenStore

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
           check_auth_token(headers[:authorization], me, "create"),
         normalized = normalize_params(params),
         {filename, filecontent, path} <-
           PostTypeDiscovery.discover(Utils.as_map(normalized))
           |> Hugo.new(DateTime.now!("Europe/Paris"), normalized),
         {:ok, :content_created} <- backend().new_file(filename, filecontent),
         content_url <- generate_published_url(me, path),
         syndicate_to = extract_syndication_targets(normalized),
         {:ok, _} <-
           Webmentions.Sender.schedule_webmentions(
             content_url,
             syndicate_to,
             Application.get_env(:last_crusader, :webmention_nb_tries, 15)
           ) do
      {:ok, content_url}
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
    original_page = params["original_page"]
    comment_author = params["author"]
    comment_content = params["comment"]
    comment_date = Hugo.convert_date_to_hugo_format(now)
    comment_link = params["link"]

    comment_yml_template = """
    date: <%= date %>
    author: <%= author %><%= if link != nil do %>
    link: <%= link %><% end %>
    comment: |
      <%= content %>
    """

    with :ok <- all_not_nil?([original_page, comment_author, comment_content]),
         fileroot <-
           Hugo.reverse_url_root(original_page, Application.get_env(:last_crusader, :me)),
         {:ok, _page_exists} <- backend().get_file(fileroot <> "/index.md") do
      comment_filename =
        fileroot <> "/comments/" <> Integer.to_string(DateTime.to_unix(now, :second)) <> ".yml"

      comment_filecontent =
        EEx.eval_string(comment_yml_template,
          date: comment_date,
          author: comment_author,
          link: comment_link,
          content: comment_content
        )

      {backend().new_file(comment_filename, comment_filecontent), comment_filecontent}
    end
  end

  defp all_not_nil?(l) do
    case Enum.all?(l) do
      true -> :ok
      false -> {:error, :missing_parameter}
    end
  end

  @doc """
  Adds a keyword to a published post (most of the time, it will be the syndication link).
  """
  def add_keyword_to_post(published_page_url, {newkey, value}) do
    host = Application.get_env(:last_crusader, :me)
    filename = Hugo.reverse_url(published_page_url, host)

    with {:ok, filecontent} <- backend().get_file(filename),
         {frontmatter, markdown} <- Toml.extract_frontmatter_and_content(filecontent),
         new_frontmatter <- Toml.update_toml(frontmatter, {newkey, value}),
         {:ok, :content_updated} <- backend().update_file(filename, new_frontmatter <> markdown) do
      {:ok, published_page_url}
    end
  end

  defp extract_syndication_targets(normalized) when is_list(normalized) do
    case List.keyfind(normalized, "mp-syndicate-to", 0) ||
           List.keyfind(normalized, "syndicate-to", 0) do
      {_, targets} when is_list(targets) -> targets
      {_, target} when is_binary(target) -> [target]
      nil -> []
    end
  end

  defp extract_syndication_targets(params) when is_map(params) do
    targets = Map.get(params, "mp-syndicate-to") || Map.get(params, "syndicate-to") || []
    List.wrap(targets)
  end

  defp backend,
    do: Application.get_env(:last_crusader, :git_backend, LastCrusader.Micropub.GitHub)

  defp normalize_params(%{"properties" => properties}) do
    Enum.map(properties, fn
      {k, [v]} when is_binary(v) -> {k, v}
      {k, v} -> {k, v}
    end)
  end

  defp normalize_params(params), do: params

  defp check_auth_token(auth_header, me, required_scope) do
    with token when is_binary(token) <- extract_bearer(auth_header),
         %{me: ^me, scope: scope} when is_binary(scope) <-
           TokenStore.read({:access_token, token}),
         true <- required_scope in String.split(scope) do
      {:ok, :valid}
    else
      _ -> {:error, :bad_token}
    end
  end

  defp extract_bearer("Bearer " <> token), do: token
  defp extract_bearer(_), do: nil

  defp generate_published_url(host, path) do
    host <> path
  end
end
