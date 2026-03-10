defmodule LastCrusader.Webmentions.ReceiverHandlerTest do
  use ExUnit.Case, async: false
  import Plug.Test
  import Plug.Conn
  alias LastCrusader.Webmentions.ReceivedWebmention
  alias LastCrusader.Repo

  @opts LastCrusader.Router.init([])

  setup do
    Repo.delete_all(ReceivedWebmention)
    :ok
  end

  describe "POST /webmention" do
    test "missing source returns 400" do
      conn =
        conn(:post, "/webmention", "target=https://mysite.com/note/1")
        |> put_req_header("content-type", "application/x-www-form-urlencoded")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "missing target returns 400" do
      conn =
        conn(:post, "/webmention", "source=https://example.com/post")
        |> put_req_header("content-type", "application/x-www-form-urlencoded")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "both missing returns 400" do
      conn =
        conn(:post, "/webmention", "")
        |> put_req_header("content-type", "application/x-www-form-urlencoded")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "valid source and target returns 202" do
      conn =
        conn(
          :post,
          "/webmention",
          "source=https://example.com/post&target=https://mysite.com/note/1"
        )
        |> put_req_header("content-type", "application/x-www-form-urlencoded")

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 202
    end
  end
end
