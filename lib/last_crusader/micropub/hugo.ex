defmodule LastCrusader.Micropub.Hugo do
  @moduledoc """
  Generates Hugo compatile data, file content, file name
"""

  @doc """
  Create a new Hugo Note type
"""
  def note(date, data) do
    new(:note, date, data)
  end

  @doc """
    Create a new Hugo Post type
  """

  def post(date, data) do
    new(:post, date, data)
  end

  @doc """
    Create a new Hugo Bookmark type
  """
  def bookmark(date, data) do
    new(:bookmark, date, data)
  end

  @doc false
  def new(type, date, data) do
    %{name: name, content: content} = data
    {:ok, path_date} = Timex.format(date, "%Y/%m/%d", :strftime)
    file_name = generate_filename(type, name, path_date)

    front_matter = generate_front_matter(date)

    {file_name, front_matter <> content}
  end

  def generate_front_matter(date) do
    {:ok, iso_date} = Timex.format(date, "{ISO:Extended}")
    "+++\ndate = " <> iso_date <> "\n+++\n"
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
