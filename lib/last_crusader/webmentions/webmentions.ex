defmodule LastCrusader.Webmentions.Webmention do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias LastCrusader.Repo

  @doc false
  schema "webmentions" do
    field(:url_source, :string)
    field(:url_target, :string)

    timestamps()
  end

  @doc false
  def changeset(webmention, params \\ %{}) do
    webmention
    |> cast(params, [:url_source, :url_source])
    |> validate_required([:url_source, :url_source])
  end

  @doc false
  def register_webmention(webmention) do
    webmention |> changeset |> Repo.insert!()
  end
end
