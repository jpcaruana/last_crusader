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
    file_name = generate_filename(type, name, date)

    front_matter = """
+++
date = 2020-08-12T00:00:00+02:00
+++
"""

    {file_name, front_matter <> content}
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
