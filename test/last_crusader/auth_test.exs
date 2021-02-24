defmodule LastCrusader.AuthTest do
  @moduledoc false

  use ExUnit.Case, async: false
  use Plug.Test
  alias LastCrusader.Cache.MemoryTokenStore, as: MemoryTokenStore

  @opts LastCrusader.Router.init([])

  test "auth should redirect to web application" do
    conn =
      conn(
        :get,
        "/auth?me=https://aaronparecki.com/&client_id=https://webapp.example.org/&redirect_uri=https://webapp.example.org/auth/callback&state=1234567890&response_type=id"
      )

    conn = LastCrusader.Router.call(conn, @opts)

    assert_redirect(
      conn,
      302,
      "https://webapp.example.org/auth/callback?code=xxxxxxxx&state=1234567890"
    )
  end

  test "auth should receive the client_id parameter" do
    conn =
      conn(
        :get,
        "/auth?me=https://aaronparecki.com/&redirect_uri=https://webapp.example.org/auth/callback&state=1234567890&response_type=id"
      )

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "auth should receive the redirect_uri parameter" do
    conn =
      conn(
        :get,
        "/auth?me=https://aaronparecki.com/&client_id=https://webapp.example.org/&state=1234567890&response_type=id"
      )

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "auth should receive the me parameter" do
    conn =
      conn(
        :get,
        "/auth?client_id=https://webapp.example.org/&redirect_uri=https://webapp.example.org/auth/callback&state=1234567890&response_type=id"
      )

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "auth should reject invalid client_id" do
    conn =
      conn(
        :get,
        "/auth?me=https://aaronparecki.com/&client_id=invalid://webapp.example.org/&redirect_uri=https://webapp.example.org/auth/callback&state=1234567890&response_type=id"
      )

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  # TODO: fix this flaky test
  #  test "token read from cache" do
  #    MemoryTokenStore.cache({"REDIRECT", "CLIENT_ID"}, {"ABCD", "url_me"})
  #
  #    conn =
  #      conn(
  #        :post,
  #        "/auth?redirect_uri=REDIRECT&client_id=CLIENT_ID&code=ABCD"
  #      )
  #
  #    # Invoke the plug
  #    conn = LastCrusader.Router.call(conn, @opts)
  #
  #    # Assert the response and status
  #    assert conn.state == :sent
  #    assert conn.resp_body == "{\"me\":\"url_me\"}"
  #    assert Plug.Conn.get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]
  #    assert conn.status == 200
  #  end

  test "read from cache fails on bad token" do
    MemoryTokenStore.cache({"REDIRECT", "CLIENT_ID"}, {"ABCD", "url_me"})

    conn =
      conn(
        :post,
        "/auth?redirect_uri=REDIRECT&client_id=CLIENT_ID&code=BAD_TOKEN"
      )

    # Invoke the plug
    conn = LastCrusader.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 401
    assert conn.resp_body == "Unauthorized"
  end

  test "fail read from cache" do
    conn =
      conn(
        :post,
        "/auth?redirect_uri=toto&client_id=client_id&code=code"
      )

    # Invoke the plug
    conn = LastCrusader.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 401
    assert conn.resp_body == "Unauthorized"
  end

  defp assert_redirect(conn, code, _to) do
    assert conn.state == :sent
    assert conn.status == code
    # assert Plug.Conn.get_resp_header(conn, "location") == [to]
  end
end
