defmodule LastCrusader.Micropub.MicropubTest do
  use ExUnit.Case, async: true
  alias LastCrusader.Micropub

  describe "Micropub.add_keyword_to_post/2" do
    test "success" do
      LastCrusader.Micropub.MockGithub.mock_ok_update_doc()

      published_page_url = "https://some.url.fr/notes/2021/08/06/test.hthml"

      {:ok, ^published_page_url} =
        Micropub.add_keyword_to_post(published_page_url, {"newkey", "value"})
    end
  end

  describe "Micropub.comment/2" do
    test "success" do
      LastCrusader.Micropub.MockGithub.mock_ok_update_doc()

      params = %{
        :author => "Author of the Comment",
        :original_page => "https://some.url.fr/notes/2021/07/15/a-post/",
        :comment => "This is the comment: Great content!",
        :link => "https://some-user-page.com/"
      }

      expected_text = """
      date: 2015-01-24T00:50:07+01:00
      author: Author of the Comment
      link: https://some-user-page.com/
      comment: |
        This is the comment: Great content!
      """

      assert {{:ok, :content_created}, expected_text} == Micropub.comment(params, now())
    end
  end

  defp now() do
    # int value: 1422057007
    # Hugo value: 2015-01-24T00:50:07+01:00
    {:ok, fake_now, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
    fake_now
  end
end
