defmodule LastCrusader.Micropub.Hugo do
  @moduledoc """
    Generates Hugo compatible data, file content, file name
  """
  alias LastCrusader.Micropub.PostTypeDiscovery, as: Post
  @type toml() :: String.t()
  @type path() :: String.t()
  @type url() :: String.t()

  @doc """
    Create a new Hugo document
  """
  @spec new(Post.post_type(), DateTime.t(), map()) :: {path(), toml(), path()}
  def new(type, date, data) do
    {text, content} =
      data
      |> Enum.map(fn {a, b} -> {String.to_atom(a), b} end)
      |> Map.new()
      |> Map.pop(:content)

    name = generate_name(content[:name], text)

    path_date = Calendar.strftime(date, "%Y/%m/%d")
    file_name = "content/" <> generate_path(type, name, path_date) <> ".md"
    web_path = generate_path(type, name, path_date) <> "/"

    front_matter = generate_front_matter(date, type, content)

    {file_name, front_matter <> not_empty(text), web_path}
  end

  @doc """
    Generates TOML formatted fron-matter
  """
  @spec generate_front_matter(DateTime.t(), Post.post_type(), map()) :: toml()
  def generate_front_matter(date, type, data \\ %{}) do
    iso_date = Calendar.strftime(date, "%Y-%m-%dT%H:%M:%S+00:00")

    data_as_toml =
      data
      |> Map.delete(:h)
      |> rename_key(:category, :tags)
      |> values_as_list(:tags)
      |> conditional_rename_key(type == :bookmark, :tags, :bookmarktags)
      |> rename_key(:"bookmark-of", :bookmark)
      |> rename_key(:"in-reply-to", :in_reply_to)
      |> rename_key(:"like-of", :like_of)
      |> rename_key(:"repost-of", :repost_of)
      |> rename_key(:"syndicate-to", :syndicate_to)
      |> rename_key(:"mp-syndicate-to", :syndicate_to)
      |> rename_key(:name, :title)
      |> Map.put(:date, iso_date)
      |> Enum.map(fn {k, v} -> to_string(k) <> " = " <> toml_value(v) end)
      |> Enum.join("\n")

    "+++\n" <> data_as_toml <> "\n+++\n"
  end

  defp toml_value(s) when is_list(s) do
    toml =
      Enum.map(s, fn x -> toml_value(x) end)
      |> Enum.join(", ")

    "[" <> toml <> "]"
  end

  defp toml_value(s) do
    "\"" <> s <> "\""
  end

  @doc """
    Extracts links from a Hugo post

    Parameters:
    - toml_content: the file's content (with TOML frontmatter)

    Some help from http://scottradcliff.com/parsing-hyperlinks-in-markdown.html

    Yes, using a Regex is weak...

    Handles my personal special case with my "indienews" shortcode
  """
  @spec extract_links(toml()) :: list(url())
  def extract_links(toml_content) do
    [_, frontmatter, markdown] = String.split(toml_content, "+++\n")

    Enum.uniq(extract_links_in_content(markdown) ++ extract_links_in_frontmatter(frontmatter))
  end

  defp extract_links_in_content(content) do
    patched_content =
      String.replace(content, "{{< indienews >}}", "[indienews](https://news.indieweb.org/fr)")

    Regex.scan(~r/\[(?<text>[\w\s]+)\]\((?<url>https?\:\/\/.*\..*)\)/U, patched_content)
    |> Enum.map(fn x -> Enum.at(x, 2) end)
  end

  defp extract_links_in_frontmatter(frontmatter) do
    with [matching_frontmatter_lines] <-
           frontmatter
           |> String.split("\n")
           |> Enum.filter(fn x -> Regex.match?(~r/^(bookmark|in_reply_to|syndicate_to) =/, x) end),
         link <-
           matching_frontmatter_lines
           |> String.split(" = ")
           |> List.last()
           |> String.replace("\"", "") do
      enrich_webmention_target_from_silos(link, String.split(link, "/", parts: 4))
    else
      _ -> []
    end
  end

  defp enrich_webmention_target_from_silos(link, ["https:", "", "twitter.com", _]) do
    [link, "https://brid.gy/publish/twitter"]
  end

  defp enrich_webmention_target_from_silos(link, ["https:", "", "github.com", _]) do
    [link, "https://brid.gy/publish/github"]
  end

  defp enrich_webmention_target_from_silos(link, _) do
    [link]
  end

  @doc """
    Generates the complete filename (with path) for a Hugo website

    Parameters:
    - type: can be `:note` `:post` `:bookmark` `in_reply_to`
    - name: for the file name
    - date
  """
  @spec generate_path(Post.post_type(), String.t(), DateTime.t()) :: path()
  def generate_path(:note, name, date) do
    "notes/" <> date <> "/" <> name
  end

  def generate_path(:in_reply_to, name, date) do
    "notes/" <> date <> "/" <> name
  end

  def generate_path(:like_of, name, date) do
    "notes/" <> date <> "/" <> name
  end

  def generate_path(:repost_of, name, date) do
    "notes/" <> date <> "/" <> name
  end

  def generate_path(:article, name, date) do
    "posts/" <> date <> "/" <> name
  end

  def generate_path(:bookmark, name, date) do
    "bookmarks/" <> date <> "/" <> name
  end

  def generate_path(_, _, _) do
    :error
  end

  defp conditional_rename_key(map, condition, old_key, new_key) do
    if condition do
      rename_key(map, old_key, new_key)
    else
      map
    end
  end

  defp rename_key(map, old_key, new_key) do
    if Map.has_key?(map, old_key) do
      Map.put(map, new_key, map[old_key])
      |> Map.delete(old_key)
    else
      map
    end
  end

  defp values_as_list(map, key) do
    if Map.has_key?(map, key) do
      value = map[key]
      Map.put(map, key, List.flatten([] ++ [value]))
    else
      map
    end
  end

  defp generate_name(nil, nil) do
    Integer.to_string(Enum.random(10..100_000))
  end

  defp generate_name(nil, text) do
    slug(text)
  end

  defp generate_name(name, _) do
    slug(name)
  end

  defp slug(text) do
    text
    |> RemoveEmoji.sanitize()
    |> String.replace("—", "-")
    |> String.replace("–", "-")
    |> Slugger.slugify_downcase()
    |> Slugger.truncate_slug(31)
  end

  defp not_empty(nil) do
    ""
  end

  defp not_empty(text) do
    text
  end
end
