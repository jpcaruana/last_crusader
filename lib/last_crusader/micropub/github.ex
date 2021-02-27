defmodule LastCrusader.Micropub.GitHub do
  @moduledoc """
    Posts content to github
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.github.com")
  plug(Tesla.Middleware.Headers, %{"User-Agent" => "Last Crusader"})
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.FormUrlencoded)

  @doc """
  Creates a commit with the filecontent to GitHub
  """
  def new_file(auth, user, repo, filename, filecontent, branch \\ "master") do
    # ex: auth=%{access_token: "928392873982932"}
    body = %{
      "branch" => branch,
      "message" => "new #{filename}\n\nposted with LastCrusader :)",
      "content" => Base.encode64(filecontent)
    }

    case build_client(auth)
         |> commit_new_file(user, repo, filename, body) do
      {:ok, %Tesla.Env{status: 201}} -> {:ok, :content_created}
      _ -> {:ko, :github_error}
    end
  end

  # see Github API documentation:
  # https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
  defp commit_new_file(client, user, repo, filename, body) do
    Tesla.put(client, "/repos/#{user}/#{repo}/contents/#{filename}", body)
  end

  # build dynamic client based on runtime arguments
  defp build_client(auth) do
    middleware = [
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{auth.access_token}"}]}
    ]

    Tesla.client(middleware)
  end
end
