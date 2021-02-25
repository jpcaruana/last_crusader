defmodule LastCrusader.Micropub.Hugo do
  @moduledoc """
    Generates Hugo compatible data, file content, file name
  """

  @doc """
    Create a new Hugo document
  """
  def new(type, date, data) do
    {text, content} =
      data
      |> Enum.map(fn {a, b} -> {String.to_atom(a), b} end)
      |> Map.new()
      |> Map.pop(:content)

    name = generate_name(content[:name], text)

    {:ok, path_date} = Timex.format(date, "%Y/%m/%d", :strftime)
    file_name = "content/" <> generate_path(type, name, path_date) <> ".md"
    web_path = generate_path(type, name, path_date) <> "/"

    front_matter = generate_front_matter(date, type, content)

    {file_name, front_matter <> not_empty(text), web_path}
  end

  @doc """
    Generates TOML formatted fron-matter
  """
  def generate_front_matter(date, type, data \\ %{}) do
    {:ok, iso_date} = Timex.format(date, "{ISO:Extended}")

    data_as_toml =
      data
      |> Map.delete(:h)
      |> rename_key(:category, :tags)
      |> values_as_list(:tags)
      |> conditional_rename_key(type == :bookmark, :tags, :bookmarktags)
      |> rename_key(:"bookmark-of", :bookmark)
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
  """
  def extract_links(toml_content) do
    [_, frontmatter, markdown] = String.split(toml_content, "+++\n")

    Enum.uniq(extract_links_in_content(markdown) ++ extract_links_in_frontmatter(frontmatter))
  end

  defp extract_links_in_content(content) do
    Regex.scan(~r/\[(?<text>[\w\s]+)\]\((?<url>https?\:\/\/.*\..*)\)/U, content)
    |> Enum.map(fn x -> Enum.at(x, 2) end)
  end

  defp extract_links_in_frontmatter(frontmatter) do
    with [matching_boorkmark_line] <-
           frontmatter
           |> String.split("\n")
           |> Enum.filter(fn x -> Regex.match?(~r/^bookmark =/, x) end),
         link <-
           matching_boorkmark_line
           |> String.split(" = ")
           |> List.last()
           |> String.replace("\"", "") do
      [link]
    else
      _ -> []
    end
  end

  @doc """
    Generates the complete filename (with path) for a Hugo website

    Parameters:
    - type: can be `:note` `:post` `:bookmark`
    - name: for the file name
    - date
  """
  def generate_path(:note, name, date) do
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
