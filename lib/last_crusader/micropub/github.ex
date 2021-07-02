defmodule LastCrusader.Micropub.GitHub do
  @moduledoc """
    Posts content to github
  """
  alias Poison, as: Json

  @doc """
  Creates a commit with the filecontent to GitHub
  """
  @spec new_file(map(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:error, atom()} | {:ok, any()}
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

  @doc """
  Updates a file on GitHub
  """
  @spec new_file(map(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:error, atom()} | {:ok, any()}
  def update_file(auth, user, repo, filename, filecontent, branch \\ "master") do
    client = build_client(auth)

    with {:ok, sha} <- get_file_sha(client, user, repo, filename, branch),
         {:ok, result} <- update_file(client, user, repo, filename, filecontent, sha, branch) do
      {:ok, result}
    else
      _ -> {:ko, :github_error}
    end
  end

  # see Github API documentation:
  # https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
  defp commit_new_file(client, user, repo, filename, body) do
    Tesla.put(client, "/repos/#{user}/#{repo}/contents/#{filename}", body)
  end

  defp get_file_content(client, user, repo, filename, ref) do
    Tesla.get(client, "/repos/#{user}/#{repo}/contents/#{filename}", query: [ref: ref])
  end

  defp update_file(client, user, repo, filename, filecontent, sha, branch) do
    body = %{
      "branch" => branch,
      "message" => "update #{filename}\n\nposted with LastCrusader :)",
      "sha" => sha,
      "content" => Base.encode64(filecontent)
    }

    case client
         |> commit_new_file(user, repo, filename, body) do
      {:ok, %Tesla.Env{status: 200}} -> {:ok, :content_updated}
      _ -> :ko
    end
  end

  defp get_file_sha(client, user, repo, filename, ref) do
    case client
         |> get_file_content(user, repo, filename, ref) do
      {:ok, %Tesla.Env{status: 200, body: %{sha: sha}}} -> {:ok, sha}
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, Json.decode!(body)["sha"]}
      _ -> :ko
    end
  end

  defp build_client(auth) do
    {:ok, version} = :application.get_key(:last_crusader, :vsn)

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.github.com"},
      {Tesla.Middleware.JSON, engine: Poison},
      Tesla.Middleware.FormUrlencoded,
      {Tesla.Middleware.Headers,
       [
         {"User-Agent", "Last Crusader/#{version}"},
         {"Authorization", "Bearer #{auth.access_token}"}
       ]}
    ]

    Tesla.client(middleware)
  end
end
