defmodule LastCrusader.Micropub.GitHub do
  @moduledoc """
    Posts content to github
  """

  def new_file(auth, user, repo, commit_message, filename, filecontent, branch \\ "master") do
    # ex: auth=%{access_token: "928392873982932"}
    body = %{
      "branch" => branch,
      "message" => commit_message <> "\n\nposted with LastCrusader :)",
      "content" => Base.encode64(filecontent)
    }

    {201, _, _} =
      Tentacat.Client.new(auth)
      |> Tentacat.Contents.create(user, repo, filename, body)
  end
end
