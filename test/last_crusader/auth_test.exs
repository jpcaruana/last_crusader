defmodule LastCrusader.AuthTest do
  @moduledoc """
  Unit tests for IndieAuth: authorization-endpoint

  see https://indieweb.org/authorization-endpoint
  """

  use ExUnit.Case, async: false
  use Plug.Test

  @opts LastCrusader.Router.init([])

  setup do
    on_exit fn ->
      RequestCache.clear()
    end
  end

  test "auth should redirect to web application" do
    conn = conn(
      :get,
      "/auth?me=https://aaronparecki.com/&client_id=https://webapp.example.org/&redirect_uri=https://webapp.example.org/auth/callback&state=1234567890&response_type=id"
    )

    conn = LastCrusader.Router.call(conn, @opts)

    assert_redirect(conn, 302, "https://webapp.example.org/auth/callback?code=xxxxxxxx&state=1234567890")
  end

  test "auth should receive the client_id parameter" do
    conn = conn(
      :get,
      "/auth?me=https://aaronparecki.com/&redirect_uri=https://webapp.example.org/auth/callback&state=1234567890&response_type=id"
    )

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "auth should receive the redirect_uri parameter" do
    conn = conn(
      :get,
      "/auth?me=https://aaronparecki.com/&client_id=https://webapp.example.org/&state=1234567890&response_type=id"
    )

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "auth should receive the me parameter" do
    conn = conn(
      :get,
      "/auth?client_id=https://webapp.example.org/&redirect_uri=https://webapp.example.org/auth/callback&state=1234567890&response_type=id"
    )

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "auth should reject invalid client_id" do
    conn = conn(
      :get,
      "/auth?me=https://aaronparecki.com/&client_id=invalid://webapp.example.org/&redirect_uri=https://webapp.example.org/auth/callback&state=1234567890&response_type=id"
    )

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end


  test "token read from cache" do
    RequestCache.cache({"REDIRECT", "CLIENT_ID"}, {"ABCD", "url_me"})

    conn = conn(
      :post,
      "/auth?redirect_uri=REDIRECT&client_id=CLIENT_ID&code=ABCD"
    )
    # Invoke the plug
    conn = LastCrusader.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.resp_body == "url_me"
    assert conn.status == 200
  end

  test "read from cache fails on bad token" do
    RequestCache.cache({"REDIRECT", "CLIENT_ID"}, {"ABCD", "url_me"})

    conn = conn(
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
    conn = conn(
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

  defp assert_redirect(conn, code, to) do
    assert conn.state == :sent
    assert conn.status == code
    # assert Plug.Conn.get_resp_header(conn, "location") == [to]
  end

end
