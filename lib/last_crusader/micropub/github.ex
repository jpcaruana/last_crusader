defmodule LastCrusader.Micropub.GitHub do
  @moduledoc """
    Posts content to github
  """
  require Logger

  @doc """
  shortcut for `new_file/6`

  Uses `Application.get_env/2` for default parameters.
  """
  @spec new_file(String.t(), String.t()) :: {:ko, atom()} | {:ok, any()}
  def new_file(filename, filecontent) do
    new_file(
      Application.get_env(:last_crusader, :github_auth),
      Application.get_env(:last_crusader, :github_user),
      Application.get_env(:last_crusader, :github_repo),
      filename,
      filecontent,
      Application.get_env(:last_crusader, :github_branch, "master")
    )
  end

  @doc """
  Creates a commit with the filecontent to GitHub
  """
  @spec new_file(map(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ko, atom()} | {:ok, any()}
  def new_file(auth, user, repo, filename, filecontent, branch \\ "master") do
    # ex: auth=%{access_token: "928392873982932"}
    body = %{
      "branch" => branch,
      "message" => "new #{filename}\n\nposted with LastCrusader :)",
      "content" => Base.encode64(filecontent)
    }

    case build_client(auth)
         |> commit_new_file(user, repo, filename, body) do
      {:ok, %Tesla.Env{status: status}} when status in [200, 201] ->
        {:ok, :content_created}

      error ->
        Logger.error("Github: Error while creating file #{inspect(filename)}:")
        {:ko, :github_error, error}
    end
  end

  @doc """
  shortcut for `update_file/6`

  Uses `Application.get_env/2` for default parameters.
  """
  @spec update_file(String.t(), String.t()) :: {:ko, atom()} | {:ok, any()}
  def update_file(filename, filecontent) do
    update_file(
      Application.get_env(:last_crusader, :github_auth),
      Application.get_env(:last_crusader, :github_user),
      Application.get_env(:last_crusader, :github_repo),
      filename,
      filecontent,
      Application.get_env(:last_crusader, :github_branch, "master")
    )
  end

  @doc """
  Updates a file on GitHub
  """
  @spec update_file(map(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ko, atom()} | {:ok, any()}
  def update_file(auth, user, repo, filename, filecontent, branch \\ "master") do
    client = build_client(auth)

    with {:ok, sha} <- get_file_sha(client, user, repo, filename, branch),
         {:ok, result} <- update_file(client, user, repo, filename, filecontent, sha, branch) do
      {:ok, result}
    else
      error ->
        Logger.error("Github: Error while updating file #{inspect(filename)}:")
        {:ko, :github_error, error}
    end
  end

  @doc """
  shortcut for `get_file/5`

  Uses `Application.get_env/2` for default parameters.
  """
  @spec get_file(String.t()) :: {:ko, atom()} | {:ok, any()}
  def get_file(filename) do
    get_file(
      Application.get_env(:last_crusader, :github_auth),
      Application.get_env(:last_crusader, :github_user),
      Application.get_env(:last_crusader, :github_repo),
      filename,
      Application.get_env(:last_crusader, :github_branch, "master")
    )
  end

  @doc """
  Gets file content from GitHub
  """
  @spec get_file(map(), String.t(), String.t(), String.t(), String.t()) ::
          {:ko, atom()} | {:ok, any()}
  def get_file(auth, user, repo, filename, branch \\ "master") do
    case get_file_content(build_client(auth), user, repo, filename, branch) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        body["content"]
        |> String.replace("\n", "")
        |> Base.decode64()

      error ->
        Logger.error("Github: Error while getting file #{inspect(filename)}:")
        {:ko, :github_error, error}
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

    case commit_new_file(client, user, repo, filename, body) do
      {:ok, %Tesla.Env{status: 200}} -> {:ok, :content_updated}
      _ -> :ko
    end
  end

  defp get_file_sha(client, user, repo, filename, ref) do
    case get_file_content(client, user, repo, filename, ref) do
      {:ok, %Tesla.Env{status: 200, body: %{sha: sha}}} -> {:ok, sha}
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body["sha"]}
      _ -> :ko
    end
  end

  defp build_client(auth) do
    {:ok, version} = :application.get_key(:last_crusader, :vsn)

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.github.com"},
      {Tesla.Middleware.JSON, engine: Jason},
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
