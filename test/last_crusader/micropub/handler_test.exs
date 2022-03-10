defmodule LastCrusader.Micropub.MicropubHandlerTest do
  @moduledoc false

  use ExUnit.Case, async: false
  use Plug.Test

  @opts LastCrusader.Router.init([])

  describe "config endpoint" do
    test "it should return 404 on unkown queries" do
      conn = conn(:get, "/micropub?q=unkkown_query")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 404
    end

    test "it should return supported types" do
      conn = conn(:get, "/micropub?q=config")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      assert Plug.Conn.get_resp_header(conn, "content-type") == [
               "application/json; charset=utf-8"
             ]

      assert conn.resp_body ==
               ~S({"syndicate-to":[{"name":"Twitter","uid":"https://twitter.com/some_twitter_account"}],"types":{"post-types":[{"name":"Note","type":"note"}]}})
    end

    test "it should return syndication targets" do
      conn = conn(:get, "/micropub?q=syndicate-to")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      assert Plug.Conn.get_resp_header(conn, "content-type") == [
               "application/json; charset=utf-8"
             ]

      assert conn.resp_body ==
               ~S({"syndicate-to":[{"name":"Twitter","uid":"https://twitter.com/some_twitter_account"}]})
    end
  end
end
