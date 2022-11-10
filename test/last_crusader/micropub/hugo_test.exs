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

  describe "Hugo.extract_links/1" do
    test "no link, always add fediverse" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content
      """

      assert Hugo.extract_links(toml_content) == ["https://fed.brid.gy/"]
    end

    test "one link" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content:
      Here is [a link](https://some-url.org/).
      """

      assert Hugo.extract_links(toml_content) == ["https://some-url.org/", "https://fed.brid.gy/"]
    end

    test "one fake link" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content:
      Here is [not a link] (https://not-some-url.org/).
      """

      assert Hugo.extract_links(toml_content) == ["https://fed.brid.gy/"]
    end

    test "special case: one link from personal hugo short code indienews" do
      toml_content = """
      +++
      key = "value"
      +++
      Some markdown content:
      {{< indienews >}}
      """

      assert Hugo.extract_links(toml_content) == [
               "https://news.indieweb.org/fr",
               "https://fed.brid.gy/"
             ]
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
               "https://news.indieweb.org/fr",
               "https://fed.brid.gy/"
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
               "https://some-other-url.org/page",
               "https://fed.brid.gy/"
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
               "http://some-other-url.org/page",
               "https://fed.brid.gy/"
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

      assert Hugo.extract_links(toml_content) == ["https://some-url.org/", "https://fed.brid.gy/"]
    end

    test "one link from bookmark" do
      toml_content = """
      +++
      key = "value"
      bookmark = "https://some-url.org/"
      +++
      Some markdown content
      """

      assert Hugo.extract_links(toml_content) == ["https://some-url.org/", "https://fed.brid.gy/"]
    end

    test "one link from like_of" do
      toml_content = """
      +++
      key = "value"
      like_of = "https://some-url.org/"
      +++
      Some markdown content
      """

      assert Hugo.extract_links(toml_content) == ["https://some-url.org/", "https://fed.brid.gy/"]
    end

    test "one link from bookmark also in content" do
      toml_content = """
      +++
      key = "value"
      bookmark = "https://some-url.org/"
      +++
      Some markdown content with [the same](https://some-url.org/) URL.
      """

      assert Hugo.extract_links(toml_content) == ["https://some-url.org/", "https://fed.brid.gy/"]
    end

    test "reply to one silo link: webmention is handled by brid.ly: twitter" do
      toml_content = """
      +++
      key = "value"
      in_reply_to = "https://twitter.com/user/status/tweet_id"
      +++
      Some markdown content.
      """

      assert Hugo.extract_links(toml_content) == [
               "https://twitter.com/user/status/tweet_id",
               "https://brid.gy/publish/twitter",
               "https://fed.brid.gy/"
             ]
    end

    test "syndication to one silo link (twitter): webmention is handled by brid.ly: twitter" do
      toml_content = """
      +++
      key = "value"
      syndicate_to = "https://twitter.com/user/"
      +++
      Some markdown content.
      """

      assert Hugo.extract_links(toml_content) == [
               "https://twitter.com/user/",
               "https://brid.gy/publish/twitter",
               "https://fed.brid.gy/"
             ]
    end

    test "reply to one silo link: webmention is handled by brid.ly: github" do
      toml_content = """
      +++
      key = "value"
      in_reply_to = "https://github.com/user/repo/issues"
      +++
      Some markdown content.
      """

      assert Hugo.extract_links(toml_content) == [
               "https://github.com/user/repo/issues",
               "https://brid.gy/publish/github",
               "https://fed.brid.gy/"
             ]
    end

    test "reply to one silo link: webmention is handled by brid.ly: my mastodon choice" do
      toml_content = """
      +++
      key = "value"
      syndicate_to = "https://indieweb.social/@some_user"
      +++
      Some markdown content.
      """

      assert Hugo.extract_links(toml_content) == [
               "https://indieweb.social/@some_user",
               "https://brid.gy/publish/mastodon",
               "https://fed.brid.gy/"
             ]
    end

    test "reply to several silo link: webmention is handled by brid.ly: twitter and mastodon" do
      toml_content = """
      +++
      key = "value"
      syndicate_to = ["https://twitter.com/user/", "https://indieweb.social/@some_user"]
      +++
      Some markdown content.
      """

      assert Hugo.extract_links(toml_content) == [
               "https://twitter.com/user/",
               "https://brid.gy/publish/twitter",
               "https://indieweb.social/@some_user",
               "https://brid.gy/publish/mastodon",
               "https://fed.brid.gy/"
             ]
    end

    test "real life failure: in_reply_to + syndicate_to + links in content" do
      toml_content = """
      +++
      date = "2021-04-16T13:29:07+00:00"
      in_reply_to = "https://aaronparecki.com/2021/04/13/26/indieauth"
      syndicate_to = "https://twitter.com/jpcaruana"
      tags = ["indieweb", "indieauth"]
      +++
      Thank you for this excellent step by step guide, much clearer, I think, than the [spec](https://indieauth.spec.indieweb.org/) or the explanation on [indieweb.org](https://indieweb.org/IndieAuth)

      {{< indienews >}}
      """

      assert Hugo.extract_links(toml_content) == [
               "https://indieauth.spec.indieweb.org/",
               "https://indieweb.org/IndieAuth",
               "https://news.indieweb.org/fr",
               "https://aaronparecki.com/2021/04/13/26/indieauth",
               "https://twitter.com/jpcaruana",
               "https://brid.gy/publish/twitter",
               "https://fed.brid.gy/"
             ]
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
