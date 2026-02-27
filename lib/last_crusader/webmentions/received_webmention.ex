defmodule LastCrusader.Webmentions.ReceivedWebmention do
  @moduledoc false
  use Ecto.Schema

  @type t :: %__MODULE__{
          id: integer() | nil,
          source: String.t() | nil,
          target: String.t() | nil,
          status: String.t(),
          inserted_at: NaiveDateTime.t() | nil
        }

  schema "received_webmentions" do
    field(:source, :string)
    field(:target, :string)
    field(:status, :string, default: "pending")
    timestamps(type: :naive_datetime, updated_at: false)
  end
end
