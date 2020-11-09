defmodule LastCrusader.Micropub.MicropubHandlerTest do
  @moduledoc false

  use ExUnit.Case, async: false
  use Plug.Test

  @opts LastCrusader.Router.init([])

  test "config endpoint should return 404 on unkown queries" do
    conn = conn(:get, "/micropub?q=unkkown_query")

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "config endpoint should return supported types" do
    conn = conn(:get, "/micropub?q=config")

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Plug.Conn.get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]
    # assert "post-types" in conn.resp_body
  end
end
