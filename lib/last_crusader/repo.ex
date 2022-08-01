defmodule LastCrusader.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :last_crusader,
    adapter: Ecto.Adapters.SQLite3
end
