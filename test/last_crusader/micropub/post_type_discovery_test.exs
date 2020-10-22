defmodule LastCrusader.Micropub.PostTypeDiscoveryTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import LastCrusader.Micropub.PostTypeDiscovery

  test "defaults to Note" do
    assert :note == discover(nil)
  end

  test "1. rvsp" do
    assert :rvsp == discover(%{rvsp: "yes"})
    assert :rvsp == discover(%{rvsp: "no"})
    assert :rvsp == discover(%{rvsp: "maybe"})
    assert :rvsp == discover(%{rvsp: "interested"})
    assert :rvsp == discover(%{rvsp: "iNtEreSTed"})

    assert :rvsp != discover(%{rvsp: "invalid RVSP value"})
  end

  test "1. rvsp priority over in-reply-to" do
    assert :rvsp == discover(%{rvsp: "yes", "in-reply-to": "http://some.url/"})
  end

  test "2. in-reply-to" do
    assert :in_reply_to == discover(%{"in-reply-to": "http://some.url/"})
    # assert :in_reply_to != discover(%{"in-reply-to": "invalid URL value"})
  end

  test "3. repost-of" do
    assert :repost_of == discover(%{"repost-of": "http://some.url/"})
  end

  test "4. like-of" do
    assert :like_of == discover(%{"like-of": "http://some.url/"})
  end

  test "5. video" do
    assert :video == discover(%{video: "http://some.url/"})
  end

  test "6. photo" do
    assert :photo == discover(%{photo: "http://some.url/"})
  end

  @doc """
      name = get_plain_text(props.get('name'))
      content = get_plain_text(props.get('content'))
      if not content:
          content = get_plain_text(props.get('summary'))
      if content and name and is_name_a_title?(name, content):
          return 'article'
      return 'note'
  """
  test "7-15. article" do
    assert :article == discover(%{name: "A Title", content: "Here is the content"})
    assert :article == discover(%{name: "A Title", summary: "Here is the content"})
    assert :article == discover(%{name: "A Title", content: "", summary: "Here is the content"})
  end

  test "always default to note post" do
    assert :note == discover(%{description: "no content nor summary property"})
    assert :note == discover(%{content: "no title, just plain and dull content"})
    assert :note == discover(%{summary: "no title, just a summary"})
    assert :note == discover(%{name: "Name is same as content", content: "Name is same as content"})
    assert :note == discover(%{name: "Name is same as summary", summary: "Name is same as summary"})
  end

  test "find title in name: simple case" do
    assert false == is_name_a_title?("this is the content", "this is the content")
    assert true == is_name_a_title?("This is a title", "This is some content")
  end

  test "find title in name: common case with no explicit p-name" do
    assert false == is_name_a_title?("nonsensethe contentnonsense", "the content")
  end

  test "find title in name: ignore case, spaces and punctuation" do
    assert false == is_name_a_title?("the content", "ThE cONTeNT")
    assert false == is_name_a_title?("the content", "the content...")
    assert false == is_name_a_title?("the content", " the  content  ")
  end
end
