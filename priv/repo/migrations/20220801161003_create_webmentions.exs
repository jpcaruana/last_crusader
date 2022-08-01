defmodule LastCrusader.Repo.Migrations.CreateWebmentions do
  use Ecto.Migration

  def change do
    create table(:webmentions) do
      add :url_source, :string
      add :url_target, :string

      timestamps()
    end
  end
end
