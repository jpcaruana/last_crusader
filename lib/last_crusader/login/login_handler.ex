defmodule LastCrusader.Login.LoginHandler do
  @moduledoc false
  import Plug.Conn

  def log_user(conn) do
    user = conn.body_params["user"]
    password = conn.body_params["password"]

    {code, content} =
      case {user, password} do
        {"jp", "pwd"} -> {200, "ok"}
        _ -> {400, "bad user/password"}
      end

    conn
    |> send_resp(code, content)
  end
end
