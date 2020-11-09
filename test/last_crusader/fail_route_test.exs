defmodule LastCrusader.FailRouteTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts LastCrusader.Router.init([])

  test "it returns 404 when no route matches" do
    # Create a test connection
    conn = conn(:get, "/non_existent_route")

    # Invoke the plug
    conn = LastCrusader.Router.call(conn, @opts)

    # Assert the response
    assert conn.status == 404
  end

  test "favicon should return 204" do
    conn = conn(:get, "/favicon.ico")
    conn = LastCrusader.Router.call(conn, @opts)
    assert conn.status == 204
  end
end
