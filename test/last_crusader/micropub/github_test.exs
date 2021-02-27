defmodule LastCrusader.Micropub.GitHubTest do
  use ExUnit.Case, async: true
  import Tesla.Mock
  alias LastCrusader.Micropub.GitHub

  test "github file creation success" do
    doc = %Tesla.Env{
      status: 201,
      body: ok_body(),
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

  test "github file creation error" do
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

  defp ok_body() do
    "{\"content\":{\"name\":\"test.txt\",\"path\":\"test.txt\",\"sha\":\"e068544d654f426eb0b145e20d8338069b4c3851\",\"size\":19,\"url\":\"https://api.github.com/repos/github_user/github_repo/co
ntents/test.txt?ref=test\",\"html_url\":\"https://github.com/github_user/github_repo/blob/test/test.txt\",\"git_url\":\"https://api.github.com/repos/github_user/github_repo/git/blobs/e068544d654f426eb0b14
5e20d8338069b4c3851\",\"download_url\":\"https://raw.githubusercontent.com/github_user/github_repo/test/test.txt?token=AAAHXINDV4JXZDK4NHEGWCC7XUXY6\",\"type\":\"file\",\"_links\":{\"self\":\"https://api.
github.com/repos/github_user/github_repo/contents/test.txt?ref=test\",\"git\":\"https://api.github.com/repos/github_user/github_repo/git/blobs/e068544d654f426eb0b145e20d8338069b4c3851\",\"html\":\"https:/
/github.com/github_user/github_repo/blob/test/test.txt\"}},\"commit\":{\"sha\":\"fd08f572c8bca4f1058aaa876d3352f99a12f429\",\"node_id\":\"MDY6Q29tbWl0MjQxNjk4MjIxOmZkMDhmNTcyYzhiY2E0ZjEwNThhYWE4NzZkMzM1Mm
Y5OWExMmY0Mjk=\",\"url\":\"https://api.github.com/repos/github_user/github_repo/git/commits/fd08f572c8bca4f1058aaa876d3352f99a12f429\",\"html_url\":\"https://github.com/github_user/github_repo/commit/fd08
f572c8bca4f1058aaa876d3352f99a12f429\",\"author\":{\"name\":\"Some Github Username\",\"email\":\"user@mail.com\",\"date\":\"2020-11-24T16:05:38Z\"},\"committer\":{\"name\":\"Some Github Username\",\"email
\":\"user@mail.com\",\"date\":\"2020-11-24T16:05:38Z\"},\"tree\":{\"sha\":\"26256f1907eb7a9444e13cec439d5f4a9e7404a7\",\"url\":\"https://api.github.com/repos/github_user/github_repo/git/trees/26256f1907eb
7a9444e13cec439d5f4a9e7404a7\"},\"message\":\"some commit message\\n\\nposted with LastCrusader :)\",\"parents\":[{\"sha\":\"3b2d9c9fd7843002b233cbfef13c8acbf6703521\",\"url\":\"https://api.github.com/rep
os/github_user/github_repo/git/commits/3b2d9c9fd7843002b233cbfef13c8acbf6703521\",\"html_url\":\"https://github.com/github_user/github_repo/commit/3b2d9c9fd7843002b233cbfef13c8acbf6703521\"}],\"verificati
on\":{\"verified\":false,\"reason\":\"unsigned\",\"signature\":null,\"payload\":null}}}"
  end
end
