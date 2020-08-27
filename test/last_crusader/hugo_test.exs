defmodule LastCrusader.HugoTest do
  use ExUnit.Case, async: true
  alias LastCrusader.Micropub.Hugo, as: Hugo

  test "it should create a Hugo file-like for Notes" do
    {file_name, file_content} =
      Hugo.note(now(), %{name: "some-name", content: "Some markdown content\n"})

    assert file_content == """
+++
date = 2015-01-23T23:50:07+00:00
+++
Some markdown content
"""

    assert file_name == "content/notes/2015/01/23/some-name.md"
  end

  test "it should create a Hugo file-like for Posts" do
    {file_name, file_content} =
      Hugo.post(now(), %{name: "some-name", content: "Some markdown content\n"})

    assert file_content == """
+++
date = 2015-01-23T23:50:07+00:00
+++
Some markdown content
"""

    assert file_name == "content/posts/2015/01/23/some-name.md"
  end

  test "it should create a Hugo file-like for Bookmarks" do
    {file_name, file_content} =
      Hugo.bookmark(now(), %{name: "some-name", content: "Some markdown content\n"})

    assert file_content == """
+++
date = 2015-01-23T23:50:07+00:00
+++
Some markdown content
"""

    assert file_name == "content/bookmarks/2015/01/23/some-name.md"
  end

  test "generate_filename should fail on inexiting type" do
    assert :error == Hugo.generate_filename(:inexisting_type, nil, nil)
  end

  def now() do
    {:ok, fake_now, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
    fake_now
  end
end
