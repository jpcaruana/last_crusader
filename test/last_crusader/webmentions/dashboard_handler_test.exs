defmodule LastCrusader.Webmentions.DashboardHandlerTest do
  use ExUnit.Case, async: false
  import Plug.Test
  import Plug.Conn
  alias LastCrusader.Webmentions.ReceivedWebmention
  alias LastCrusader.Repo

  @opts LastCrusader.Router.init([])
  @valid_token "test-secret-token"

  setup do
    Repo.delete_all(ReceivedWebmention)
    :ok
  end

  describe "GET /webmentions" do
    test "no token returns 401" do
      conn = conn(:get, "/webmentions")
      conn = LastCrusader.Router.call(conn, @opts)
      assert conn.status == 401
    end

    test "wrong token returns 401" do
      conn = conn(:get, "/webmentions?token=wrong-token")
      conn = LastCrusader.Router.call(conn, @opts)
      assert conn.status == 401
    end

    test "correct token with empty DB returns 200 HTML" do
      conn = conn(:get, "/webmentions?token=#{@valid_token}")
      conn = LastCrusader.Router.call(conn, @opts)
      assert conn.status == 200
      assert get_resp_header(conn, "content-type") == ["text/html; charset=utf-8"]
    end

    test "correct token with records returns 200 HTML containing source/target/status" do
      Repo.insert!(%ReceivedWebmention{
        source: "https://example.com/post",
        target: "https://mysite.com/note/1",
        status: "valid"
      })

      conn = conn(:get, "/webmentions?token=#{@valid_token}")
      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 200
      assert conn.resp_body =~ "https://example.com/post"
      assert conn.resp_body =~ "https://mysite.com/note/1"
      assert conn.resp_body =~ "valid"
    end
  end
end
