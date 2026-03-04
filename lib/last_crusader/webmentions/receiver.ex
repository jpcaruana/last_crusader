defmodule LastCrusader.Webmentions.Receiver do
  @moduledoc false
  import Ecto.Changeset
  alias LastCrusader.Repo
  alias LastCrusader.Webmentions.ReceivedWebmention
  require Logger

  @doc "Stores a pending webmention and returns {:ok, id}."
  @spec accept(String.t(), String.t()) :: {:ok, integer()}
  def accept(source, target) do
    changeset =
      %ReceivedWebmention{}
      |> cast(%{source: source, target: target, status: "pending"}, [:source, :target, :status])
      |> validate_required([:source, :target])

    {:ok, record} = Repo.insert(changeset)
    {:ok, record.id}
  end

  @doc "Fetches source and verifies it links to target; updates the record status accordingly."
  @spec verify(integer(), String.t(), String.t()) :: :ok
  def verify(id, source, target) do
    status =
      if Webmentions.is_valid_mention(source, target) do
        "valid"
      else
        "invalid"
      end

    record = Repo.get!(ReceivedWebmention, id)

    record
    |> change(status: status)
    |> Repo.update!()

    Logger.info("Webmention #{id} (#{source} -> #{target}) verified: #{status}")
    :ok
  end
end
