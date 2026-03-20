defmodule LastCrusader.Repo.Migrations.CreateReceivedWebmentions do
  use Ecto.Migration

  def change do
    create table(:received_webmentions) do
      add :source, :text, null: false
      add :target, :text, null: false
      add :status, :text, null: false, default: "pending"
      timestamps(type: :naive_datetime, updated_at: false)
    end
  end
end
