defmodule LastCrusader.MicropubTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts LastCrusader.Router.init([])

  test "micropub should accept x-www-form-urlencoded requests" do
    conn = conn(:post, "/micropub", %{h: "entry", content: "some text content"})

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == "Location: http://example.com/venue/10"
  end
end
