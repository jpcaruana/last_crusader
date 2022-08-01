defmodule LastCrusader.Webmentions.Webmention do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias LastCrusader.Repo

  schema "webmentions" do
    field(:url_source, :string)
    field(:url_target, :string)

    timestamps()
  end

  def changeset(webmention, params \\ %{}) do
    webmention
    |> cast(params, [:url_source, :url_source])
    |> validate_required([:url_source, :url_source])
  end

  def register_webmention(webmention) do
    Repo.insert!(webmention)
  end
end
