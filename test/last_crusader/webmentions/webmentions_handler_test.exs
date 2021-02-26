defmodule LastCrusader.Webmentions.HandlerTest do
  @moduledoc false

  use ExUnit.Case, async: true
  use Plug.Test

  @opts LastCrusader.Router.init([])

  describe "standard error responses" do
    test "source is mandatory" do
      assert_response("/webmention", 400, "no source specified")
      assert_response("/webmention?target=http://target.com/", 400, "no source specified")
    end

    test "target is mandatory" do
      assert_response("/webmention?source=http://source.com/", 400, "no target specified")
    end

    test "source and target should differ" do
      assert_response(
        "/webmention?source=http://source.com/&target=http://source.com/",
        400,
        "source and target match"
      )
    end

    test "source scheme should be http(s)" do
      assert_response(
        "/webmention?source=ftp://source.com/&target=http://source.com/",
        400,
        "unsupported scheme for source"
      )
    end

    test "target scheme should be http(s)" do
      assert_response(
        "/webmention?source=http://source.com/&target=ftp://source.com/",
        400,
        "unsupported scheme for target"
      )
    end

    test "content-type should be form-urlencoded" do
      assert_response(
        "/webmention?source=http://source.com/&target=http://source.com/",
        415,
        "unsupported content type",
        "application/json"
      )
    end
  end

  defp assert_response(
         request,
         expected_response_code,
         expected_response_body,
         content_type \\ "application/x-www-form-urlencoded"
       ) do
    conn =
      conn(:post, request)
      |> put_req_header("content-type", content_type)

    conn = LastCrusader.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == expected_response_code
    assert conn.resp_body == expected_response_body
  end
end
