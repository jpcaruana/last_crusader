defmodule LastCrusader.Micropub.MicropubHandlerTest do
  @moduledoc false

  use ExUnit.Case, async: false
  import Tesla.Mock
  use Plug.Test
  alias Jason, as: Json

  @opts LastCrusader.Router.init([])

  describe "config endpoint" do
    test "it should return 404 on unknown queries" do
      conn = conn(:get, "/micropub?q=unknown_query")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 404
    end

    test "it should return supported types" do
      conn = conn(:get, "/micropub?q=config")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      assert Plug.Conn.get_resp_header(conn, "content-type") == [
               "application/json; charset=utf-8"
             ]

      assert conn.resp_body ==
               ~S({"types":{"post-types":[{"name":"Note","type":"note"}]},"syndicate-to":[{"name":"Twitter","uid":"https://twitter.com/some_twitter_account"}]})
    end

    test "it should return syndication targets" do
      conn = conn(:get, "/micropub?q=syndicate-to")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      assert Plug.Conn.get_resp_header(conn, "content-type") == [
               "application/json; charset=utf-8"
             ]

      assert conn.resp_body ==
               ~S({"syndicate-to":[{"name":"Twitter","uid":"https://twitter.com/some_twitter_account"}]})
    end

    test "it should return tags ordered by weight" do
      tags_from_website = %Tesla.Env{
        status: 200,
        body: tags_as_json(),
        headers: [
          {"Status", "200 OK"},
          {"Content-Type", "application/json; charset=utf-8"}
        ]
      }

      mock(fn
        %{method: :get} -> {:ok, tags_from_website}
      end)

      conn = conn(:get, "/micropub?q=category")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      assert Plug.Conn.get_resp_header(conn, "content-type") == [
               "application/json; charset=utf-8"
             ]

      assert conn.resp_body ==
               ~S({"categories":["deepki","conférences","Aujourd'hui j'ai appris","indieweb","blog","organisation"]})
    end

    test "it should fail 404 when tags request is wrong" do
      wrong_tags_from_website = %Tesla.Env{
        status: 200,
        body: """
          { "type": "request", "status": "not what we expect" }
        """,
        headers: [
          {"Status", "200 OK"},
          {"Content-Type", "application/json; charset=utf-8"}
        ]
      }

      mock(fn
        %{method: :get} -> {:ok, wrong_tags_from_website}
      end)

      conn = conn(:get, "/micropub?q=category")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 404
    end
  end

  describe "comment endpoint" do
    test "it should accept only POST queries" do
      conn = conn(:get, "/comment")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 404
    end

    test "it should reply to OPTIONS queries" do
      conn = conn(:options, "/comment")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 204
      assert Plug.Conn.get_resp_header(conn, "allow") == ["OPTIONS, POST"]
      assert Plug.Conn.get_resp_header(conn, "access-control-request-method") == ["POST"]
    end

    test "it should accept json requests" do
      LastCrusader.Micropub.MockGithub.mock_ok_update_doc()

      params = %{
        "author" => "Author of the Comment",
        "original_page" => "https://some.url.fr/notes/2021/07/15/a-post/",
        "comment" => "This is the comment: Great content!",
        "link" => "https://some-user-page.com/"
      }

      conn =
        conn(:post, "/comment", Json.encode!(params))
        |> put_req_header("content-type", "application/json")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 202
    end

    test "it should accept form-urlencoded requests" do
      LastCrusader.Micropub.MockGithub.mock_ok_update_doc()

      params = %{
        "author" => "Author of the Comment",
        "original_page" => "https://some.url.fr/notes/2021/07/15/a-post/",
        "comment" => "This is the comment: Great content!",
        "link" => "https://some-user-page.com/"
      }

      conn =
        conn(:post, "/comment", params)
        |> put_req_header("content-type", "application/x-www-form-urlencoded")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 202
    end
  end

  defp tags_as_json() do
    """
    {
        "tags": [
            {"Aujourd'hui j'ai appris": 24},
            {"blog": 11},
            {"conférences": 39},
            {"deepki": 41},
            {"indieweb": 11},
            {"organisation": 1}
        ]
    }
    """
  end
end
