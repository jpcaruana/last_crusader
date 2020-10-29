defmodule LastCrusader.Micropub.Hugo do
  @moduledoc """
    Generates Hugo compatible data, file content, file name
  """

  @doc """
    Create a new Hugo document
  """
  def new(type, date, name, data) do
    content =
      data
      |> Enum.map(fn {a, b} -> {String.to_atom(a), b} end)
      |> Map.new()

    {text, content} = Map.pop(content, :content)
    {:ok, path_date} = Timex.format(date, "%Y/%m/%d", :strftime)
    file_name = generate_filename(type, name, path_date) <> ".md"
    web_path = generate_filename(type, name, path_date) <> "/"

    front_matter = generate_front_matter(date, content)

    {file_name, front_matter <> text, web_path}
  end

  def generate_front_matter(date, data \\ %{}) do
    {:ok, iso_date} = Timex.format(date, "{ISO:Extended}")

    data_as_toml =
      data
      |> Map.delete(:h)
      |> rename_key(:category, :tags)
      |> rename_key(:name, :title)
      |> Map.put(:date, iso_date)
      |> Enum.map(fn {k, v} -> to_string(k) <> " = " <> toml_value(v) end)
      |> Enum.join("\n")

    "+++\n" <> data_as_toml <> "\n+++\n"
  end

  def toml_value(s) when is_list(s) do
    toml =
      Enum.map(s, fn x -> toml_value(x) end)
      |> Enum.join(", ")

    "[" <> toml <> "]"
  end

  def toml_value(s) do
    "\"" <> s <> "\""
  end

  @doc """
    Generates the complete filename (with path) for a Hugo website

    Parameters:
    - type: can be `:note` `:post` `:bookmark`
    - name: for the file name
    - date
  """
  def generate_filename(:note, name, date) do
    "content/notes/" <> date <> "/" <> name
  end

  def generate_filename(:article, name, date) do
    "content/posts/" <> date <> "/" <> name
  end

  def generate_filename(:bookmark, name, date) do
    "content/bookmarks/" <> date <> "/" <> name
  end

  def generate_filename(_, _, _) do
    :error
  end

  defp rename_key(map, old_key, new_key) do
    if Map.has_key?(map, old_key) do
      Map.put(map, new_key, map[old_key])
      |> Map.delete(old_key)
    else
      map
    end
  end
end
