defmodule LastCrusader.MicropubTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts LastCrusader.Router.init([])

  test "micropub should accept h-entry x-www-form-urlencoded requests" do
    conn = conn(:post, "/micropub", %{h: "entry", content: "some text content"})

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 202
    assert Plug.Conn.get_resp_header(conn, "location") == ["http://example.com/venue/10"]
  end

  test "micropub should reject bad h-entries" do
    conn = conn(:post, "/micropub", %{h: "NOPE", content: "some text content"})

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end
end
