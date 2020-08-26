defmodule LastCrusader.Micropub.Hugo do
  @moduledoc false

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

  def generate_filename(:note, name, date) do
    "content/notes/" <> date <> "/" <> name <> ".md"
  end

  def generate_filename(_, name, date) do
    :error
  end
end
