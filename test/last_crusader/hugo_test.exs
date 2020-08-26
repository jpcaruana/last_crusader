defmodule LastCrusader.HugoTest do
  use ExUnit.Case, async: true
  alias LastCrusader.Micropub.Hugo, as: Hugo

  test "it should create a Hugo file-like for Notes" do
    {file_name, file_content} =
      Hugo.new(:note, "2020/08/12", %{name: "some-name", content: "Some markdown content\n"})

    assert file_content == """
+++
date = 2020-08-12T00:00:00+02:00
+++
Some markdown content
"""

    assert file_name == "content/notes/2020/08/12/some-name.md"
  end
end
