defmodule LastCrusader.Micropub.GitLabTest do
  use ExUnit.Case, async: true
  import Tesla.Mock
  alias LastCrusader.Micropub.GitLab

  describe "GitLab.new_file/6" do
    test "file creation success" do
      mock(fn %{method: :post} ->
        {:ok, %Tesla.Env{status: 201, body: %{"file_path" => "test.txt", "branch" => "main"}}}
      end)

      assert GitLab.new_file(
               "https://gitlab.com",
               "glpat-secret",
               "namespace%2Frepo",
               "test.txt",
               "this is a text file",
               "main"
             ) == {:ok, :content_created}
    end

    test "file creation error" do
      mock(fn %{method: :post} ->
        {:ok, %Tesla.Env{status: 401, body: %{"message" => "401 Unauthorized"}}}
      end)

      assert {:ko, :gitlab_error, _} =
               GitLab.new_file(
                 "https://gitlab.com",
                 "bad-token",
                 "namespace%2Frepo",
                 "test.txt",
                 "this is a text file",
                 "main"
               )
    end
  end

  describe "GitLab.update_file/6" do
    test "file update success" do
      mock(fn %{method: :put} ->
        {:ok, %Tesla.Env{status: 200, body: %{"file_path" => "test.txt", "branch" => "main"}}}
      end)

      assert GitLab.update_file(
               "https://gitlab.com",
               "glpat-secret",
               "namespace%2Frepo",
               "test.txt",
               "this is updated content",
               "main"
             ) == {:ok, :content_updated}
    end

    test "file update error" do
      mock(fn %{method: :put} ->
        {:ok, %Tesla.Env{status: 404, body: %{"message" => "404 File Not Found"}}}
      end)

      assert {:ko, :gitlab_error, _} =
               GitLab.update_file(
                 "https://gitlab.com",
                 "glpat-secret",
                 "namespace%2Frepo",
                 "test.txt",
                 "this is updated content",
                 "main"
               )
    end
  end

  describe "GitLab.get_file/5" do
    test "get file success" do
      content = "some content in the file"

      mock(fn %{method: :get} ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: %{
             "file_name" => "test.txt",
             "content" => Base.encode64(content),
             "encoding" => "base64"
           }
         }}
      end)

      assert {:ok, ^content} =
               GitLab.get_file(
                 "https://gitlab.com",
                 "glpat-secret",
                 "namespace%2Frepo",
                 "test.txt",
                 "main"
               )
    end

    test "get file error" do
      mock(fn %{method: :get} ->
        {:ok, %Tesla.Env{status: 404, body: %{"message" => "404 File Not Found"}}}
      end)

      assert {:ko, :gitlab_error, _} =
               GitLab.get_file(
                 "https://gitlab.com",
                 "glpat-secret",
                 "namespace%2Frepo",
                 "test.txt",
                 "main"
               )
    end
  end

  describe "GitLab.new_file_via_pr/6" do
    test "MR creation success" do
      mock(fn
        %{method: :post} -> {:ok, %Tesla.Env{status: 201, body: %{"id" => 1}}}
        %{method: :put} -> {:ok, %Tesla.Env{status: 201, body: %{"file_path" => "test.txt"}}}
      end)

      assert GitLab.new_file_via_pr(
               "https://gitlab.com",
               "glpat-secret",
               "namespace%2Frepo",
               "test.txt",
               "this is a text file",
               "main"
             ) == {:ok, :pr_created}
    end

    test "MR creation fails when creating branch fails" do
      error_doc = %Tesla.Env{status: 400, body: %{"message" => "bad request"}}

      mock(fn %{method: :post} -> {:ok, error_doc} end)

      assert {:ko, :gitlab_error, _} =
               GitLab.new_file_via_pr(
                 "https://gitlab.com",
                 "glpat-secret",
                 "namespace%2Frepo",
                 "test.txt",
                 "this is a text file",
                 "main"
               )
    end
  end
end
