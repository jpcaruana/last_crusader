defmodule LastCrusader.Micropub.GitHubTest do
  use ExUnit.Case, async: true
  import Tesla.Mock
  alias LastCrusader.Micropub.GitHub
  alias Jason, as: Json

  describe "GitHub.new_file/6" do
    test "file creation success" do
      doc = %Tesla.Env{
        status: 201,
        body: ok_create_body(),
        headers: [
          {"Status", "201 Created"},
          {"Content-Type", "application/json; charset=utf-8"},
          {"Content-Length", "1977"},
          {"Server", "GitHub.com"},
          {"X-GitHub-Media-Type", "github.v3; format=json"}
        ]
      }

      mock(fn %{method: :put} -> {:ok, doc} end)

      assert GitHub.new_file(
               %{access_token: "THIS_SHOULD_STAY_A_SECRET"},
               "github_user",
               "github_repo",
               "test.txt",
               "this is a text file",
               "test"
             ) == {:ok, :content_created}
    end

    test "file creation error" do
      doc = %Tesla.Env{
        status: 401,
        body:
          "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://docs.github.com/rest\"}",
        headers: [
          {"Status", "401"},
          {"Content-Type", "application/json; charset=utf-8"},
          {"Content-Length", "80"},
          {"Server", "GitHub.com"},
          {"X-GitHub-Media-Type", "github.v3; format=json"}
        ]
      }

      mock(fn %{method: :put} -> {:ok, doc} end)

      assert GitHub.new_file(
               %{access_token: "bad credentials"},
               "github_user",
               "github_repo",
               "test.txt",
               "this is a text file",
               "test"
             ) == {:ko, :github_error}
    end
  end

  describe "GitHub.update_file/6" do
    test "file update success" do
      sha_doc = %Tesla.Env{
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

      updated_doc = %Tesla.Env{
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
        %{method: :get} -> {:ok, sha_doc}
        %{method: :put} -> {:ok, updated_doc}
      end)

      assert GitHub.update_file(
               %{access_token: "THIS_SHOULD_STAY_A_SECRET"},
               "github_user",
               "github_repo",
               "test.txt",
               "this is a text file",
               "test"
             ) == {:ok, :content_updated}
    end

    test "file update failure on PUT" do
      sha_doc = %Tesla.Env{
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

      updated_doc = %Tesla.Env{
        status: 404,
        body: Json.encode!(%{"error" => "error", "reason" => "failed"}),
        headers: [
          {"Status", "404 Not Found"},
          {"Content-Type", "application/json; charset=utf-8"},
          {"Content-Length", "1977"},
          {"Server", "GitHub.com"},
          {"X-GitHub-Media-Type", "github.v3; format=json"}
        ]
      }

      mock(fn
        %{method: :get} -> {:ok, sha_doc}
        %{method: :put} -> {:ok, updated_doc}
      end)

      assert GitHub.update_file(
               %{access_token: "THIS_SHOULD_STAY_A_SECRET"},
               "github_user",
               "github_repo",
               "test.txt",
               "this is a text file",
               "test"
             ) == {:ko, :github_error, :ko}
    end

    test "file update failure on SHA discovery: 404" do
      sha_doc = %Tesla.Env{
        status: 404,
        body: Json.encode!(%{"error" => "error", "reason" => "not found"}),
        headers: [
          {"Status", "404 OK"},
          {"Content-Type", "application/json; charset=utf-8"},
          {"Content-Length", "1977"},
          {"Server", "GitHub.com"},
          {"X-GitHub-Media-Type", "github.v3; format=json"}
        ]
      }

      mock(fn %{method: :get} -> {:ok, sha_doc} end)

      assert GitHub.update_file(
               %{access_token: "THIS_SHOULD_STAY_A_SECRET"},
               "github_user",
               "github_repo",
               "test.txt",
               "this is a text file",
               "test"
             ) == {:ko, :github_error, :ko}
    end
  end

  describe "GitHub.get_file/5" do
    test "get file success" do
      doc = %Tesla.Env{
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

      mock(fn %{method: :get} -> {:ok, doc} end)

      assert {:ok, "some content in the file"} ==
               GitHub.get_file(
                 %{access_token: "THIS_SHOULD_STAY_A_SECRET"},
                 "github_user",
                 "github_repo",
                 "test.txt",
                 "test_branch"
               )
    end
  end

  defp ok_create_body() do
    Json.encode!(%{
      "content" => %{
        "name" => "test.txt",
        "path" => "test.txt",
        "sha" => "e068544d654f426eb0b145e20d8338069b4c3851",
        "size" => 19,
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
    })
  end

  defp ok_get_sha_body() do
    Json.encode!(%{
      "_links" => %{
        "git" =>
          "https://api.github.com/repos/jpcaruana/jp.caruana.fr/git/blobs/0bbca6e0fc897c9b0122f84e09c349f0e0ae98ea",
        "html" => "https://github.com/jpcaruana/jp.caruana.fr/blob/test/test1",
        "self" => "https://api.github.com/repos/jpcaruana/jp.caruana.fr/contents/test1?ref=test"
      },
      "content" => "c29tZSBjb250ZW50IGluIHRoZSBmaWxl\n",
      "download_url" =>
        "https://raw.githubusercontent.com/jpcaruana/jp.caruana.fr/test/test1?token=AAAHXIMSLMW5HG7S6G4OCKTA34T7A",
      "encoding" => "base64",
      "git_url" =>
        "https://api.github.com/repos/jpcaruana/jp.caruana.fr/git/blobs/0bbca6e0fc897c9b0122f84e09c349f0e0ae98ea",
      "html_url" => "https://github.com/jpcaruana/jp.caruana.fr/blob/test/test1",
      "name" => "test1",
      "path" => "test1",
      "sha" => "0bbca6e0fc897c9b0122f84e09c349f0e0ae98ea",
      "size" => 24,
      "type" => "file",
      "url" => "https://api.github.com/repos/jpcaruana/jp.caruana.fr/contents/test1?ref=test"
    })
  end
end
