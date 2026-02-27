defmodule LastCrusader.MetadataHandlerTest do
  @moduledoc false

  use ExUnit.Case, async: true
  use Plug.Test

  @opts LastCrusader.Router.init([])
  @issuer "https://some.url.fr"

  describe "GET /.well-known/oauth-authorization-server" do
    test "returns JSON with all required fields" do
      conn = conn(:get, "/.well-known/oauth-authorization-server")
      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 200

      assert Plug.Conn.get_resp_header(conn, "content-type") == [
               "application/json; charset=utf-8"
             ]

      {:ok, body} = Jason.decode(conn.resp_body)

      assert body["issuer"] == @issuer
      assert body["authorization_endpoint"] == "#{@issuer}/auth"
      assert body["token_endpoint"] == "#{@issuer}/token"
      assert body["introspection_endpoint"] == "#{@issuer}/introspect"
      assert body["revocation_endpoint"] == "#{@issuer}/revoke"
      assert body["code_challenge_methods_supported"] == ["S256"]
      assert body["scopes_supported"] == ["profile", "create", "update", "delete", "media"]
    end

    test "all endpoint URLs are derived from configured issuer" do
      conn = conn(:get, "/.well-known/oauth-authorization-server")
      conn = LastCrusader.Router.call(conn, @opts)

      {:ok, body} = Jason.decode(conn.resp_body)

      for key <- [
            "authorization_endpoint",
            "token_endpoint",
            "introspection_endpoint",
            "revocation_endpoint"
          ] do
        assert String.starts_with?(body[key], @issuer),
               "#{key} should start with issuer URL"
      end
    end
  end
end
