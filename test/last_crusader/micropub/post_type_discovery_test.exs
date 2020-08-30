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
    #assert :in_reply_to != discover(%{"in-reply-to": "invalid URL value"})
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

end
