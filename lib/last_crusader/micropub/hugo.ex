defmodule LastCrusader.Micropub.Hugo do
  @moduledoc """
    Generates Hugo compatible data, file content, file name
  """
  alias LastCrusader.Micropub.PostTypeDiscovery, as: Post
  alias LastCrusader.Utils.Toml, as: Toml
  alias LastCrusader.Utils.Http, as: Utils
  @type path() :: String.t()
  @type url() :: String.t()

  @doc """
    Create a new Hugo document
  """
  @spec new(Post.post_type(), DateTime.t(), map()) :: {path(), Toml.toml(), path()}
  def new(type, date, data) do
    {text, content} =
      data
      |> Utils.as_map()
      |> Map.pop(:content)

    name = generate_name(content[:name], text, date)

    path_date = Calendar.strftime(date, "%Y/%m/%d")
    file_name = "content/" <> generate_path(type, name, path_date) <> "/index.md"
    web_path = generate_path(type, name, path_date) <> "/"

    front_matter = generate_front_matter(date, type, content)

    {file_name, front_matter <> not_empty(text), web_path}
  end

  @doc """
    Generates TOML formatted front-matter
  """
  @spec generate_front_matter(DateTime.t(), Post.post_type(), map()) :: Toml.toml()
  def generate_front_matter(date, type, data \\ %{}) do
    data
    |> Map.delete(:h)
    |> rename_key(:category, :tags)
    |> values_as_list(:tags)
    |> conditional_rename_key(type == :bookmark, :tags, :bookmarktags)
    |> rename_key(:"bookmark-of", :bookmark)
    |> rename_key(:"in-reply-to", :in_reply_to)
    |> rename_key(:"like-of", :like_of)
    |> rename_key(:"listen-of", :listen_of)
    |> rename_key(:"repost-of", :repost_of)
    |> rename_key(:"syndicate-to", :syndicate_to)
    |> rename_key(:"mp-syndicate-to", :syndicate_to)
    |> rename_key(:name, :title)
    |> Map.put(:date, convert_date_to_hugo_format(date))
    |> Toml.toml_map_to_string()
  end

  @doc """
  Renders the post date into Hugo's expected date format ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601))
  """
  @spec convert_date_to_hugo_format(DateTime.t()) :: BitString.t()
  def convert_date_to_hugo_format(date) do
    DateTime.to_iso8601(date, :extended, 3600)
  end

  @doc """
    Retrieves the local directory path of a post from its published public URL
  """
  @spec reverse_url_root(url(), url()) :: String.t()
  def reverse_url_root(post_url, host) do
    x = String.replace(post_url, host, "")
    x = Regex.replace(~r/\/(\w*)$/, x, "\\1")
    "content/" <> x
  end

  @doc """
    Retrieves the local file path of a post from its published public URL
  """
  @spec reverse_url(url(), url()) :: String.t()
  def reverse_url(post_url, host) do
    reverse_url_root(post_url, host) <> "/index.md"
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

  defp generate_name(nil, nil, date) do
    Integer.to_string(DateTime.to_unix(date, :second))
  end

  defp generate_name(nil, text, _date) do
    slug(text)
  end

  defp generate_name(name, _, _date) do
    slug(name)
  end

  defp slug(text) do
    text
    |> RemoveEmoji.sanitize()
    |> String.replace("—", "-")
    |> String.replace("–", "-")
    |> String.replace("{{< twittos ", "")
    |> String.replace(" >}}", "")
    |> String.replace(">", "")
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
