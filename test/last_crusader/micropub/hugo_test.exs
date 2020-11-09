defmodule LastCrusader.HugoTest do
  use ExUnit.Case, async: true
  alias LastCrusader.Micropub.Hugo, as: Hugo

  test "it should create a Hugo file-like for Notes" do
    {file_name, file_content, web_path} =
      Hugo.new(:note, now(), [{"content", "Some markdown content\n"}])

    assert file_content == """
           +++
           date = "2015-01-23T23:50:07+00:00"
           +++
           Some markdown content
           """

    assert file_name == "content/notes/2015/01/23/some-markdown-content.md"
    assert web_path == "content/notes/2015/01/23/some-markdown-content/"
  end

  test "it should rename name to title" do
    {file_name, file_content, _} =
      Hugo.new(:note, now(), [
        {"content", "Some other markdown content\n"},
        {"name", "My title"}
      ])

    assert file_content == """
           +++
           date = "2015-01-23T23:50:07+00:00"
           title = "My title"
           +++
           Some other markdown content
           """

    assert file_name == "content/notes/2015/01/23/my-title.md"
  end

  test "it should create a Hugo file-like for Notes with additional data" do
    {file_name, file_content, _} =
      Hugo.new(:note, now(), [
        {"content", "Some markdown content\n"},
        {"tags", ["tag1", "tag2"]},
        {"copy", "https://some/url"}
      ])

    assert file_content == """
           +++
           copy = "https://some/url"
           date = "2015-01-23T23:50:07+00:00"
           tags = ["tag1", "tag2"]
           +++
           Some markdown content
           """

    assert file_name == "content/notes/2015/01/23/some-markdown-content.md"
  end

  test "it should rename category to tags" do
    {file_name, file_content, _} =
      Hugo.new(:note, now(), [
        {"content", "Some markdown content\n"},
        {"category", ["tag1", "tag2"]}
      ])

    assert file_content == """
           +++
           date = "2015-01-23T23:50:07+00:00"
           tags = ["tag1", "tag2"]
           +++
           Some markdown content
           """

    assert file_name == "content/notes/2015/01/23/some-markdown-content.md"
  end

  test "it should transforms tags into a list" do
    {_, file_content, _} =
      Hugo.new(:note, now(), [
        {"content", "Some markdown content\n"},
        {"category", "one_tag"}
      ])

    assert file_content == """
           +++
           date = "2015-01-23T23:50:07+00:00"
           tags = ["one_tag"]
           +++
           Some markdown content
           """
  end

  test "it should shorten the generated slug for long content" do
    {file_name, _, _} =
      Hugo.new(:note, now(), [
        {"content", "it should shorten the generated slug for long content"}
      ])

    assert file_name == "content/notes/2015/01/23/it-should-shorten-the-generated.md"
  end

  test "it should shorten the generated slug for long name" do
    {file_name, _, _} =
      Hugo.new(:note, now(), [
        {"content", "some content"},
        {"content", "it should shorten the generated slug for long name"}
      ])

    assert file_name == "content/notes/2015/01/23/it-should-shorten-the-generated.md"
  end

  test "it should create article" do
    {file_name, _, _} =
      Hugo.new(:article, now(), [
        {"content", "some content"},
        {"content", "it should shorten the generated slug for long name"}
      ])

    assert file_name == "content/posts/2015/01/23/it-should-shorten-the-generated.md"
  end

  test "it should create bookmarks" do
    {file_name, _, _} =
      Hugo.new(:bookmark, now(), [
        {"content", "some content"},
        {"content", "it should shorten the generated slug for long name"}
      ])

    assert file_name == "content/bookmarks/2015/01/23/it-should-shorten-the-generated.md"
  end

  test "generate_filename should fail on inexiting type" do
    assert :error == Hugo.generate_filename(:inexisting_type, nil, nil)
  end

  def now() do
    {:ok, fake_now, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
    fake_now
  end
end
