defmodule LastCrusader.HugoTest do
  use ExUnit.Case, async: true
  alias LastCrusader.Micropub.Hugo, as: Hugo

  describe "Hugo.new/3" do
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
      assert web_path == "notes/2015/01/23/some-markdown-content/"
    end

    test "it should create a note for a in-reply-to" do
      {file_name, file_content, web_path} =
        Hugo.new(:in_reply_to, now(), [
          {"content", "Some markdown content\n"},
          {"in-reply-to", "https://some-url.com/"}
        ])

      assert file_content == """
             +++
             date = "2015-01-23T23:50:07+00:00"
             in_reply_to = "https://some-url.com/"
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content.md"
      assert web_path == "notes/2015/01/23/some-markdown-content/"
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
          {"content", "it should shorten the generated slug for long name"}
        ])

      assert file_name == "content/notes/2015/01/23/it-should-shorten-the-generated.md"
    end

    test "it should create article" do
      {file_name, _, _} =
        Hugo.new(:article, now(), [
          {"content", "some content"}
        ])

      assert file_name == "content/posts/2015/01/23/some-content.md"
    end

    test "it should create bookmarks" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content", "some content"}
        ])

      assert file_name == "content/bookmarks/2015/01/23/some-content.md"
    end

    test "it should create bookmarks with special tags: " do
      {_, file_content, _} =
        Hugo.new(:bookmark, now(), [
          {"bookmark-of", "http://some-url.com/"},
          {"category", "one_tag"}
        ])

      assert file_content == """
             +++
             bookmark = "http://some-url.com/"
             bookmarktags = ["one_tag"]
             date = "2015-01-23T23:50:07+00:00"
             +++
             """
    end

    test "it should create bookmarks with an empty content (name is random)" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content", nil},
          {"bookmark-of", "http://some-url.com/"}
        ])

      assert String.contains?(file_name, "content/bookmarks/2015/01/23/")
    end

    test "it should sanitize input from emojis to prevent UnicodeConversionError from happening" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content",
           "dwyl/phoenix-liveview-counter-tutorial: 🤯  beginners tutorial building a real time counter in Phoenix 1.5.5 + LiveView 0.14.7 ⚡️"},
          {"bookmark-of", "https://github.com/dwyl/phoenix-liveview-counter-tutorial"}
        ])

      assert file_name == "content/bookmarks/2015/01/23/dwyl-phoenix-liveview-counter.md"
    end

    test "it should sanitize input from weird '—' char to prevent strange filename from existing" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content", "Alembic — Monitoring Phoenix LiveView Performance"},
          {"bookmark-of",
           "https://alembic.com.au/blog/2021-02-05-monitoring-phoenix-liveview-performance"}
        ])

      assert file_name == "content/bookmarks/2015/01/23/alembic-monitoring-phoenix.md"
    end

    test "it should sanitize input from another weird '–' char to prevent strange filename from existing" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content", "How to Write a Book – Rands in Repose"},
          {"bookmark-of", "https://randsinrepose.com/archives/how-to-write-a-book/"}
        ])

      assert file_name == "content/bookmarks/2015/01/23/how-to-write-a-book-rands-in.md"
    end

    test "generate_filename should fail on inexiting type" do
      assert :error == Hugo.generate_path(:inexisting_type, nil, nil)
    end
  end

  describe "Hugo.extract_links/1" do
    test "no link" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content
      """

      assert Hugo.extract_links(toml_content) == []
    end

    test "one link" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content:
      Here is [a link](https://some-url.org/).
      """

      assert Hugo.extract_links(toml_content) == ["https://some-url.org/"]
    end

    test "special case: one link from personal hugo short code indienews" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content:
      {{< indienews >}}
      """

      assert Hugo.extract_links(toml_content) == ["https://news.indieweb.org/fr"]
    end

    test "special case: one link from personal hugo short code indienews and one regular link" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content:
      Here is [a link](https://some-url.org/).
      {{< indienews >}}
      """

      assert Hugo.extract_links(toml_content) == [
               "https://some-url.org/",
               "https://news.indieweb.org/fr"
             ]
    end

    test "two links" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content:
      Here is [a link](https://some-url.org/) and there [another one](https://some-other-url.org/page).
      """

      assert Hugo.extract_links(toml_content) == [
               "https://some-url.org/",
               "https://some-other-url.org/page"
             ]
    end

    test "two links: http and https" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content:
      Here is [a link](https://some-url.org/) and there [another one](http://some-other-url.org/page).
      """

      assert Hugo.extract_links(toml_content) == [
               "https://some-url.org/",
               "http://some-other-url.org/page"
             ]
    end

    test "one link twice" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content:
      Here is a [link](https://some-url.org/) and there [the same](https://some-url.org/).
      """

      assert Hugo.extract_links(toml_content) == ["https://some-url.org/"]
    end

    test "one link from bookmark" do
      toml_content = """
      +++
      key = "value"
      bookmark = "https://some-url.org/"
      +++
      Some markdown content
      """

      assert Hugo.extract_links(toml_content) == ["https://some-url.org/"]
    end

    test "one link from bookmark also in content" do
      toml_content = """
      +++
      key = "value"
      bookmark = "https://some-url.org/"
      +++
      Some markdown content with [the same](https://some-url.org/) URL.
      """

      assert Hugo.extract_links(toml_content) == ["https://some-url.org/"]
    end

    test "one silo link but webmention is handled by brid.ly: twitter" do
      toml_content = """
      +++
      key = "value"
      in-reply-to = "https://twitter.com/user/status/tweet_id"
      +++
      Some markdown content.
      """

      assert Hugo.extract_links(toml_content) == [
               "https://twitter.com/user/status/tweet_id",
               "https://brid.gy/publish/twitter"
             ]
    end

    test "one silo link but webmention is handled by brid.ly: github" do
      toml_content = """
      +++
      key = "value"
      in-reply-to = "https://github.com/user/repo/issues"
      +++
      Some markdown content.
      """

      assert Hugo.extract_links(toml_content) == [
               "https://github.com/user/repo/issues",
               "https://brid.gy/publish/github"
             ]
    end
  end

  def now() do
    {:ok, fake_now, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
    fake_now
  end
end
