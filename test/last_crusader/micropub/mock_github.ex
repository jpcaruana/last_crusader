defmodule LastCrusader.Micropub.MockGithub do
  @moduledoc false

  import Tesla.Mock

  def mock_ok_update_doc() do
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
