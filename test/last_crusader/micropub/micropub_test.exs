defmodule LastCrusader.Micropub.MicropubTest do
  use ExUnit.Case, async: false
  import Tesla.Mock
  alias LastCrusader.Micropub
  alias LastCrusader.Cache.MemoryTokenStore

  @me "https://some.url.fr/"

  defp cache_token(token, scope) do
    MemoryTokenStore.cache({:access_token, token}, %{
      me: @me,
      scope: scope,
      client_id: "https://webapp.example.org/"
    })
  end

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
        "author" => "Author of the Comment",
        "original_page" => "https://some.url.fr/notes/2021/07/15/a-post/",
        "comment" => "This is the comment: Great content!",
        "link" => "https://some-user-page.com/"
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

    test "success (link is not mandatory)" do
      LastCrusader.Micropub.MockGithub.mock_ok_update_doc()

      params = %{
        "author" => "Author of the Comment",
        "original_page" => "https://some.url.fr/notes/2021/07/15/a-post/",
        "comment" => "This is the comment: Great content!"
      }

      expected_text = """
      date: 2015-01-24T00:50:07+01:00
      author: Author of the Comment
      comment: |
        This is the comment: Great content!
      """

      assert {{:ok, :content_created}, expected_text} == Micropub.comment(params, now())
    end

    test "original_page is mandatory" do
      LastCrusader.Micropub.MockGithub.mock_ok_update_doc()

      params = %{
        "author" => "Author of the Comment",
        "comment" => "This is the comment: Great content!",
        "link" => "https://some-user-page.com/"
      }

      assert {:error, :missing_parameter} == Micropub.comment(params, now())
    end

    test "author is mandatory" do
      LastCrusader.Micropub.MockGithub.mock_ok_update_doc()

      params = %{
        "original_page" => "https://some.url.fr/notes/2021/07/15/a-post/",
        "comment" => "This is the comment: Great content!",
        "link" => "https://some-user-page.com/"
      }

      assert {:error, :missing_parameter} == Micropub.comment(params, now())
    end

    test "comment is mandatory" do
      LastCrusader.Micropub.MockGithub.mock_ok_update_doc()

      params = %{
        "author" => "Author of the Comment",
        "original_page" => "https://some.url.fr/notes/2021/07/15/a-post/",
        "link" => "https://some-user-page.com/"
      }

      assert {:error, :missing_parameter} == Micropub.comment(params, now())
    end
  end

  describe "Micropub.publish/2" do
    test "valid access token with correct me and scope allows publish" do
      cache_token("valid_token", "create")
      mock(fn %{method: :put} -> {:ok, %Tesla.Env{status: 201, body: "{}"}} end)

      params = %{
        "type" => ["h-entry"],
        "properties" => %{"content" => ["sync test, please ignore"]}
      }

      assert {:ok, url} = Micropub.publish([authorization: "Bearer valid_token"], params)
      assert url =~ "sync-test-please-ignore"
    end

    test "unknown token returns error" do
      params = %{
        "type" => ["h-entry"],
        "properties" => %{"content" => ["some content"]}
      }

      assert {:error, :bad_token} =
               Micropub.publish([authorization: "Bearer unknown_token_xyz"], params)
    end

    test "token with insufficient scope returns error" do
      cache_token("scope_token", "delete")

      params = %{
        "type" => ["h-entry"],
        "properties" => %{"content" => ["some content"]}
      }

      assert {:error, :bad_token} =
               Micropub.publish([authorization: "Bearer scope_token"], params)
    end

    test "JSON format: mp-syndicate-to is normalized to syndicate_to" do
      cache_token("syndicate_token", "create")
      test_pid = self()

      mock(fn %{method: :put, body: body} ->
        send(test_pid, {:put_body, body})
        {:ok, %Tesla.Env{status: 201, body: "{}"}}
      end)

      params = %{
        "type" => ["h-entry"],
        "properties" => %{
          "content" => ["a note"],
          "mp-syndicate-to" => ["https://indieweb.social/@user"]
        }
      }

      {:ok, _} = Micropub.publish([authorization: "Bearer syndicate_token"], params)

      assert_received {:put_body, body}
      file_content = decode_github_content(body)
      assert file_content =~ ~s(syndicate_to = "https://indieweb.social/@user")
      refute file_content =~ "mp-syndicate-to"
      refute file_content =~ "properties"
    end

    test "JSON format: multi-value category is preserved as tags list" do
      cache_token("category_token", "create")
      test_pid = self()

      mock(fn %{method: :put, body: body} ->
        send(test_pid, {:put_body, body})
        {:ok, %Tesla.Env{status: 201, body: "{}"}}
      end)

      params = %{
        "type" => ["h-entry"],
        "properties" => %{
          "content" => ["tagged note"],
          "category" => ["elixir", "indieweb"]
        }
      }

      {:ok, _} = Micropub.publish([authorization: "Bearer category_token"], params)

      assert_received {:put_body, body}
      file_content = decode_github_content(body)
      assert file_content =~ ~s(tags = ["elixir", "indieweb"])
    end

    test "form-encoded format still works unchanged" do
      cache_token("form_token", "create")
      mock(fn %{method: :put} -> {:ok, %Tesla.Env{status: 201, body: "{}"}} end)

      params = %{"content" => "a form-encoded note", "h" => "entry"}

      assert {:ok, url} = Micropub.publish([authorization: "Bearer form_token"], params)
      assert url =~ "a-form-encoded-note"
    end
  end

  defp now() do
    # int value: 1422057007
    # Hugo value: 2015-01-24T00:50:07+01:00
    {:ok, fake_now, 0} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
    fake_now
  end

  defp decode_github_content(body) do
    {:ok, body_map} = Jason.decode(body)
    Base.decode64!(body_map["content"], ignore: :whitespace)
  end
end
