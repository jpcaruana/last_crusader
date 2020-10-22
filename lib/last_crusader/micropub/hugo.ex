defmodule LastCrusader.Micropub.Hugo do
  @moduledoc """
    Generates Hugo compatible data, file content, file name
  """

  @doc """
    Create a new Hugo Note type
  """
  def note(date, name, content, data \\ %{}) do
    new(:note, date, name, content, data)
  end

  @doc """
    Create a new Hugo Post type
  """
  def post(date, name, content, data \\ %{}) do
    new(:post, date, name, content, data)
  end

  @doc """
    Create a new Hugo Bookmark type
  """
  def bookmark(date, name, content, data \\ %{}) do
    new(:bookmark, date, name, content, data)
  end

  @doc false
  def new(type, date, name, content, data \\ %{}) do
    {:ok, path_date} = Timex.format(date, "%Y/%m/%d", :strftime)
    file_name = generate_filename(type, name, path_date)

    front_matter = generate_front_matter(date, data)

    {file_name, front_matter <> content}
  end

  def generate_front_matter(date, data \\ %{}) do
    {:ok, iso_date} = Timex.format(date, "{ISO:Extended}")

    data_as_toml =
      data
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
    "content/notes/" <> date <> "/" <> name <> ".md"
  end

  def generate_filename(:post, name, date) do
    "content/posts/" <> date <> "/" <> name <> ".md"
  end

  def generate_filename(:bookmark, name, date) do
    "content/bookmarks/" <> date <> "/" <> name <> ".md"
  end

  def generate_filename(_, _, _) do
    :error
  end
end
