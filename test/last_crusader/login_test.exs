defmodule LastCrusader.LoginTest do
  @moduledoc false

  use ExUnit.Case, async: false
  use Plug.Test

  @opts LastCrusader.Router.init([])

  test "reject bad logins" do
    conn = conn(:post, "/login", %{user: "jp", password: "bad password"})

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "accept hard coded logins" do
    conn = conn(:post, "/login", %{user: "jp", password: "pwd"})

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
  end
end
