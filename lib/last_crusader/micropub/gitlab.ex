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
