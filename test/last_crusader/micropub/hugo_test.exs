defmodule LastCrusader.HugoTest do
  use ExUnit.Case, async: true
  alias LastCrusader.Micropub.Hugo, as: Hugo

  describe "Hugo.new/3" do
    test "it should create a Hugo file-like for Notes" do
      {file_name, file_content, web_path} =
        Hugo.new(:note, now(), [{"content", "Some markdown content\n"}])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
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
             date = "2015-01-24T00:50:07+01:00"
             in_reply_to = "https://some-url.com/"
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
      assert web_path == "notes/2015/01/23/some-markdown-content/"
    end

    test "it should create a note for a like-of" do
      {file_name, file_content, web_path} =
        Hugo.new(:like_of, now(), [
          {"content", "Some markdown content\n"},
          {"like-of", "https://some-url.com/"}
        ])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
             like_of = "https://some-url.com/"
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
      assert web_path == "notes/2015/01/23/some-markdown-content/"
    end

    test "it should create a note for a listen-of" do
      {file_name, file_content, web_path} =
        Hugo.new(:like_of, now(), [
          {"content", "Some markdown content\n"},
          {"listen-of", "https://some-url.com/"}
        ])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
             listen_of = "https://some-url.com/"
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
      assert web_path == "notes/2015/01/23/some-markdown-content/"
    end

    test "it should create a note for a repost-of" do
      {file_name, file_content, web_path} =
        Hugo.new(:repost_of, now(), [
          {"content", "Some markdown content\n"},
          {"repost-of", "https://some-url.com/"}
        ])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
             repost_of = "https://some-url.com/"
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
      assert web_path == "notes/2015/01/23/some-markdown-content/"
    end

    test "it should create a Hugo file-like for with syndicate-to meta-data" do
      {file_name, file_content, web_path} =
        Hugo.new(:note, now(), [
          {"content", "Some markdown content\n"},
          {"syndicate-to", "https://some-url.com/"}
        ])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
             syndicate_to = "https://some-url.com/"
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
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
             date = "2015-01-24T00:50:07+01:00"
             title = "My title"
             +++
             Some other markdown content
             """

      assert file_name == "content/notes/2015/01/23/my-title/index.md"
    end

    test "it should generate a name without Hugo special code" do
      {file_name, file_content, web_path} =
        Hugo.new(:note, now(), [{"content", "Some {{< twittos markdown >}} content\n"}])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
             +++
             Some {{< twittos markdown >}} content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
      assert web_path == "notes/2015/01/23/some-markdown-content/"
    end

    test "it should generate a name without mardown quote" do
      {file_name, file_content, web_path} =
        Hugo.new(:note, now(), [{"content", "> Some markdown content\n"}])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
             +++
             > Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
      assert web_path == "notes/2015/01/23/some-markdown-content/"
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
             date = "2015-01-24T00:50:07+01:00"
             tags = ["tag1", "tag2"]
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
    end

    test "it should rename category to tags" do
      {file_name, file_content, _} =
        Hugo.new(:note, now(), [
          {"content", "Some markdown content\n"},
          {"category", ["tag1", "tag2"]}
        ])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
             tags = ["tag1", "tag2"]
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
    end

    test "it should rename mp-syndicate-to to syndicate_to (micropublish.net)" do
      {file_name, file_content, _} =
        Hugo.new(:note, now(), [
          {"content", "Some markdown content\n"},
          {"mp-syndicate-to", "https://some-url.com/"}
        ])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
             syndicate_to = "https://some-url.com/"
             +++
             Some markdown content
             """

      assert file_name == "content/notes/2015/01/23/some-markdown-content/index.md"
    end

    test "it should transforms tags into a list" do
      {_, file_content, _} =
        Hugo.new(:note, now(), [
          {"content", "Some markdown content\n"},
          {"category", "one_tag"}
        ])

      assert file_content == """
             +++
             date = "2015-01-24T00:50:07+01:00"
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

      assert file_name == "content/notes/2015/01/23/it-should-shorten-the-generated/index.md"
    end

    test "it should shorten the generated slug for long name" do
      {file_name, _, _} =
        Hugo.new(:note, now(), [
          {"content", "it should shorten the generated slug for long name"}
        ])

      assert file_name == "content/notes/2015/01/23/it-should-shorten-the-generated/index.md"
    end

    test "it should create article" do
      {file_name, _, _} =
        Hugo.new(:article, now(), [
          {"content", "some content"}
        ])

      assert file_name == "content/posts/2015/01/23/some-content/index.md"
    end

    test "it should create bookmarks" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content", "some content"}
        ])

      assert file_name == "content/bookmarks/2015/01/23/some-content/index.md"
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
             date = "2015-01-24T00:50:07+01:00"
             +++
             """
    end

    test "it should create bookmarks with an empty content" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content", nil},
          {"bookmark-of", "http://some-url.com/"}
        ])

      assert file_name == "content/bookmarks/2015/01/23/1422057007/index.md"
    end

    test "it should sanitize input from emojis to prevent UnicodeConversionError from happening" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content",
           "dwyl/phoenix-liveview-counter-tutorial: 🤯  beginners tutorial building a real time counter in Phoenix 1.5.5 + LiveView 0.14.7 ⚡️"},
          {"bookmark-of", "https://github.com/dwyl/phoenix-liveview-counter-tutorial"}
        ])

      assert file_name == "content/bookmarks/2015/01/23/dwyl-phoenix-liveview-counter/index.md"
    end

    test "it should sanitize input from weird '—' char to prevent strange filename from existing" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content", "Alembic — Monitoring Phoenix LiveView Performance"},
          {"bookmark-of",
           "https://alembic.com.au/blog/2021-02-05-monitoring-phoenix-liveview-performance"}
        ])

      assert file_name == "content/bookmarks/2015/01/23/alembic-monitoring-phoenix/index.md"
    end

    test "it should sanitize input from another weird '–' char to prevent strange filename from existing" do
      {file_name, _, _} =
        Hugo.new(:bookmark, now(), [
          {"content", "How to Write a Book – Rands in Repose"},
          {"bookmark-of", "https://randsinrepose.com/archives/how-to-write-a-book/"}
        ])

      assert file_name == "content/bookmarks/2015/01/23/how-to-write-a-book-rands-in/index.md"
    end

    test "generate_filename should fail on non existing type" do
      assert :error == Hugo.generate_path(:inexisting_type, nil, nil)
    end
  end

  describe "Hugo.reverse_url/2 --  Hugo.reverse_url_root/2" do
    test "Reverse post path: URL -> filepath" do
      assert "content/notes/2021/07/15/a-post/index.md" ==
               Hugo.reverse_url(
                 "https://some.web.com/notes/2021/07/15/a-post/",
                 "https://some.web.com/"
               )

      assert "content/notes/2021/07/15/a-post" ==
               Hugo.reverse_url_root(
                 "https://some.web.com/notes/2021/07/15/a-post/",
                 "https://some.web.com/"
               )
    end
  end

  defp now() do
    {:ok, fake_now, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
    fake_now
  end
end
