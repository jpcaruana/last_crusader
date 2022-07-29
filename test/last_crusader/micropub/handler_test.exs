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
               ~S({"syndicate-to":[{"name":"Twitter","uid":"https://twitter.com/some_twitter_account"}],"types":{"post-types":[{"name":"Note","type":"note"}]}})
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

    test "it should accept json requests" do
      filecontent_doc = %Tesla.Env{
        status: 200,
        body: ok_get_sha_body(),
        headers: [
          {"Status", "200 OK"},
          {"Content-Type", "application/json; charset=utf-8"},
          {"Content-Length", "1977"},
          {"Server", "GitHub.com"},
          {"X-GitHub-Media-Type", "github.v3; format=json"}
        ]
      }

      comment_doc = %Tesla.Env{
        status: 200,
        body: ok_create_body(),
        headers: [
          {"Status", "200 OK"},
          {"Content-Type", "application/json; charset=utf-8"},
          {"Content-Length", "1977"},
          {"Server", "GitHub.com"},
          {"X-GitHub-Media-Type", "github.v3; format=json"}
        ]
      }

      mock(fn
        %{method: :get} -> {:ok, filecontent_doc}
        %{method: :put} -> {:ok, comment_doc}
      end)

      params = %{
        :author => "Author of the Comment",
        :original_page => "https://some.url.fr/notes/2021/07/15/a-post/",
        :comment => "This is the comment: Great content!",
        :link => "https://some-user-page.com/"
      }

      conn =
        conn(:post, "/comment", Json.encode!(params))
        |> put_req_header("content-type", "application/json")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 202
    end

    test "it should accept form-urlencoded requests" do
      filecontent_doc = %Tesla.Env{
        status: 200,
        body: ok_get_sha_body(),
        headers: [
          {"Status", "200 OK"},
          {"Content-Type", "application/json; charset=utf-8"},
          {"Content-Length", "1977"},
          {"Server", "GitHub.com"},
          {"X-GitHub-Media-Type", "github.v3; format=json"}
        ]
      }

      comment_doc = %Tesla.Env{
        status: 200,
        body: ok_create_body(),
        headers: [
          {"Status", "200 OK"},
          {"Content-Type", "application/json; charset=utf-8"},
          {"Content-Length", "1977"},
          {"Server", "GitHub.com"},
          {"X-GitHub-Media-Type", "github.v3; format=json"}
        ]
      }

      mock(fn
        %{method: :get} -> {:ok, filecontent_doc}
        %{method: :put} -> {:ok, comment_doc}
      end)

      params = %{
        :author => "Author of the Comment",
        :original_page => "https://some.url.fr/notes/2021/07/15/a-post/",
        :comment => "This is the comment: Great content!",
        :link => "https://some-user-page.com/"
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

  defp ok_create_body() do
    %{
      "content" => %{
        "name" => "test.txt",
        "path" => "test.txt",
        "sha" => "e068544d654f426eb0b145e20d8338069b4c3851",
        "size" => 64,
        "url" =>
          "https://api.github.com/repos/github_user/github_repo/contents/test.txt?ref=test",
        "html_url" => "https://github.com/github_user/github_repo/blob/test/test.txt",
        "git_url" =>
          "https://api.github.com/repos/github_user/github_repo/git/blobs/e068544d654f426eb0b145e20d8338069b4c3851",
        "download_url" =>
          "https://raw.githubusercontent.com/github_user/github_repo/test/test.txt?token=AZIUHSDIHE",
        "type" => "file",
        "_links" => %{
          "self" =>
            "https://api. github.com/repos/github_user/github_repo/contents/test.txt?ref=test",
          "git" =>
            "https://api.github.com/repos/github_user/github_repo/git/blobs/e068544d654f426eb0b145e20d8338069b4c3851",
          "html" => "https => / /github.com/github_user/github_repo/blob/test/test.txt"
        }
      },
      "commit" => %{
        "sha" => "fd08f572c8bca4f1058aaa876d3352f99a12f429",
        "node_id" =>
          "MDY6Q29tbWl0MjQxNjk4MjIxOmZkMDhmNTcyYzhiY2E0ZjEwNThhYWE4NzZkMzM1Mm Y5OWExMmY0Mjk=",
        "url" =>
          "https://api.github.com/repos/github_user/github_repo/git/commits/fd08f572c8bca4f1058aaa876d3352f99a12f429",
        "html_url" =>
          "https://github.com/github_user/github_repo/commit/fd08 f572c8bca4f1058aaa876d3352f99a12f429",
        "author" => %{
          "name" => "Some Github Username",
          "email" => "user@mail.com",
          "date" => "2020-11-24T16 => 05 => 38Z"
        },
        "committer" => %{
          "name" => "Some Github Username",
          "email " => "user@mail.com",
          "date" => "2020-11-24T16 => 05 => 38Z"
        },
        "tree" => %{
          "sha" => "26256f1907eb7a9444e13cec439d5f4a9e7404a7",
          "url" =>
            "https://api.github.com/repos/github_user/github_repo/git/trees/26256f1907eb 7a9444e13cec439d5f4a9e7404a7"
        },
        "message" => "some commit message\\n\\nposted with LastCrusader :)",
        "parents" => [
          %{
            "sha" => "3b2d9c9fd7843002b233cbfef13c8acbf6703521",
            "url" =>
              "https://api.github.com/rep os/github_user/github_repo/git/commits/3b2d9c9fd7843002b233cbfef13c8acbf6703521",
            "html_url" =>
              "https://github.com/github_user/github_repo/commit/3b2d9c9fd7843002b233cbfef13c8acbf6703521"
          }
        ],
        "verification" => %{
          "verified" => false,
          "reason" => "unsigned",
          "signature" => nil,
          "payload" => nil
        }
      }
    }
  end

  defp ok_get_sha_body() do
    %{
      "_links" => %{
        "git" =>
          "https://api.github.com/repos/jpcaruana/jp.caruana.fr/git/blobs/b18938a758c1ff3386e4fefa512a3b21717b9868",
        "html" =>
          "https://github.com/jpcaruana/jp.caruana.fr/blob/master/content/notes/2021/08/06/test3.md",
        "self" =>
          "https://api.github.com/repos/jpcaruana/jp.caruana.fr/contents/content/notes/2021/08/06/test3.md?ref=master"
      },
      "content" =>
        "KysrCmRhdGUgPSAiMjAyMS0wOC0wNlQxODo0MzoyNiswMDowMCIKc3luZGlj\nYXRlX3RvID0gImh0dHBzOi8vdHdpdHRlci5jb20vanBjYXJ1YW5hIgorKysK\ndGVzdDM=\n",
      "download_url" =>
        "https://raw.githubusercontent.com/jpcaruana/jp.caruana.fr/master/content/notes/2021/08/06/test3.md?token=AAAHXIMLGFGC4BZJHSVPIXTBBVTWQ",
      "encoding" => "base64",
      "git_url" =>
        "https://api.github.com/repos/jpcaruana/jp.caruana.fr/git/blobs/b18938a758c1ff3386e4fefa512a3b21717b9868",
      "html_url" =>
        "https://github.com/jpcaruana/jp.caruana.fr/blob/master/content/notes/2021/08/06/test3.md",
      "name" => "test3.md",
      "path" => "content/notes/2021/08/06/test3.md",
      "sha" => "b18938a758c1ff3386e4fefa512a3b21717b9868",
      "size" => 95,
      "type" => "file",
      "url" =>
        "https://api.github.com/repos/jpcaruana/jp.caruana.fr/contents/content/notes/2021/08/06/test3.md?ref=master"
    }
  end
end
