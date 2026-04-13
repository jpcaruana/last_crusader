defmodule LastCrusader.Micropub.GitLab do
  @moduledoc """
    Posts content to GitLab
  """
  @behaviour LastCrusader.Micropub.Backend

  require Logger

  @impl LastCrusader.Micropub.Backend
  @spec new_file(String.t(), String.t()) :: {:ko, atom(), any()} | {:ok, :content_created}
  def new_file(filename, filecontent) do
    new_file(
      Application.get_env(:last_crusader, :gitlab_host, "https://gitlab.com"),
      Application.get_env(:last_crusader, :gitlab_token),
      Application.get_env(:last_crusader, :gitlab_project_id),
      filename,
      filecontent,
      Application.get_env(:last_crusader, :gitlab_branch, "main")
    )
  end

  @impl LastCrusader.Micropub.Backend
  @doc """
  shortcut for `new_file_via_pr/6`

  Uses `Application.get_env/2` for default parameters.
  """
  @spec new_file_via_pr(String.t(), String.t()) :: {:ko, atom(), any()} | {:ok, :pr_created}
  def new_file_via_pr(filename, filecontent) do
    new_file_via_pr(
      Application.get_env(:last_crusader, :gitlab_host, "https://gitlab.com"),
      Application.get_env(:last_crusader, :gitlab_token),
      Application.get_env(:last_crusader, :gitlab_project_id),
      filename,
      filecontent,
      Application.get_env(:last_crusader, :gitlab_branch, "main")
    )
  end

  @doc """
  Creates a commit with the filecontent to GitLab
  """
  @spec new_file(String.t(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ko, atom(), any()} | {:ok, :content_created}
  def new_file(host, token, project_id, filename, filecontent, branch) do
    body = %{
      "branch" => branch,
      "commit_message" => "new #{filename}\n\nposted with LastCrusader :)",
      "content" => Base.encode64(filecontent),
      "encoding" => "base64"
    }

    encoded_path = URI.encode(filename, &URI.char_unreserved?/1)

    case Tesla.post(
           build_client(host, token),
           "/api/v4/projects/#{project_id}/repository/files/#{encoded_path}",
           body
         ) do
      {:ok, %Tesla.Env{status: status}} when status in [200, 201] ->
        {:ok, :content_created}

      error ->
        Logger.error("GitLab: Error while creating file #{inspect(filename)}:")
        {:ko, :gitlab_error, error}
    end
  end

  @doc """
  Creates a commit with the filecontent to GitLab via a merge request
  """
  @spec new_file_via_pr(String.t(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ko, atom(), any()} | {:ok, :pr_created}
  def new_file_via_pr(host, token, project_id, filename, filecontent, branch) do
    client = build_client(host, token)
    timestamp = :os.system_time(:second)
    comment_branch = "comment/#{timestamp}"

    with {:ok, _} <- create_branch(client, project_id, comment_branch, branch),
         {:ok, _} <-
           commit_file_on_branch(client, project_id, filename, filecontent, comment_branch),
         {:ok, _} <- create_merge_request(client, project_id, comment_branch, branch) do
      {:ok, :pr_created}
    else
      error ->
        Logger.error("GitLab: Error while creating MR for #{inspect(filename)}:")
        {:ko, :gitlab_error, error}
    end
  end

  @impl LastCrusader.Micropub.Backend
  @spec update_file(String.t(), String.t()) :: {:ko, atom(), any()} | {:ok, :content_updated}
  def update_file(filename, filecontent) do
    update_file(
      Application.get_env(:last_crusader, :gitlab_host, "https://gitlab.com"),
      Application.get_env(:last_crusader, :gitlab_token),
      Application.get_env(:last_crusader, :gitlab_project_id),
      filename,
      filecontent,
      Application.get_env(:last_crusader, :gitlab_branch, "main")
    )
  end

  @doc """
  Updates a file on GitLab
  """
  @spec update_file(String.t(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ko, atom(), any()} | {:ok, :content_updated}
  def update_file(host, token, project_id, filename, filecontent, branch) do
    body = %{
      "branch" => branch,
      "commit_message" => "update #{filename}\n\nposted with LastCrusader :)",
      "content" => Base.encode64(filecontent),
      "encoding" => "base64"
    }

    encoded_path = URI.encode(filename, &URI.char_unreserved?/1)

    case Tesla.put(
           build_client(host, token),
           "/api/v4/projects/#{project_id}/repository/files/#{encoded_path}",
           body
         ) do
      {:ok, %Tesla.Env{status: 200}} ->
        {:ok, :content_updated}

      error ->
        Logger.error("GitLab: Error while updating file #{inspect(filename)}:")
        {:ko, :gitlab_error, error}
    end
  end

  @impl LastCrusader.Micropub.Backend
  @spec get_file(String.t()) :: {:ko, atom(), any()} | {:ok, String.t()}
  def get_file(filename) do
    get_file(
      Application.get_env(:last_crusader, :gitlab_host, "https://gitlab.com"),
      Application.get_env(:last_crusader, :gitlab_token),
      Application.get_env(:last_crusader, :gitlab_project_id),
      filename,
      Application.get_env(:last_crusader, :gitlab_branch, "main")
    )
  end

  @doc """
  Gets file content from GitLab
  """
  @spec get_file(String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ko, atom(), any()} | {:ok, String.t()}
  def get_file(host, token, project_id, filename, branch) do
    encoded_path = URI.encode(filename, &URI.char_unreserved?/1)

    case Tesla.get(
           build_client(host, token),
           "/api/v4/projects/#{project_id}/repository/files/#{encoded_path}",
           query: [ref: branch]
         ) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        body["content"]
        |> String.replace("\n", "")
        |> Base.decode64()

      error ->
        Logger.error("GitLab: Error while getting file #{inspect(filename)}:")
        {:ko, :gitlab_error, error}
    end
  end

  defp create_branch(client, project_id, new_branch, base_branch) do
    body = %{
      "branch" => new_branch,
      "ref" => base_branch
    }

    case Tesla.post(client, "/api/v4/projects/#{project_id}/repository/branches", body) do
      {:ok, %Tesla.Env{status: 201}} -> {:ok, :created}
      {:ok, %Tesla.Env{status: _}} -> :error
      error -> error
    end
  end

  defp commit_file_on_branch(client, project_id, filename, filecontent, branch) do
    body = %{
      "branch" => branch,
      "commit_message" => "new #{filename}\n\nposted with LastCrusader :)",
      "content" => Base.encode64(filecontent),
      "encoding" => "base64"
    }

    encoded_path = URI.encode(filename, &URI.char_unreserved?/1)

    case Tesla.post(
           client,
           "/api/v4/projects/#{project_id}/repository/files/#{encoded_path}",
           body
         ) do
      {:ok, %Tesla.Env{status: 201}} -> {:ok, :committed}
      {:ok, %Tesla.Env{status: _}} -> :error
      error -> error
    end
  end

  defp create_merge_request(client, project_id, head_branch, base_branch) do
    body = %{
      "title" => "Comment submission",
      "source_branch" => head_branch,
      "target_branch" => base_branch
    }

    case Tesla.post(client, "/api/v4/projects/#{project_id}/merge_requests", body) do
      {:ok, %Tesla.Env{status: 201}} -> {:ok, :mr_created}
      {:ok, %Tesla.Env{status: _}} -> :error
      error -> error
    end
  end

  defp build_client(host, token) do
    {:ok, version} = :application.get_key(:last_crusader, :vsn)

    middleware = [
      {Tesla.Middleware.BaseUrl, host},
      {Tesla.Middleware.JSON, engine: Jason},
      {Tesla.Middleware.Headers,
       [
         {"User-Agent", "Last Crusader/#{version}"},
         {"PRIVATE-TOKEN", token}
       ]}
    ]

    Tesla.client(middleware)
  end
end
