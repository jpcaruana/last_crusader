defmodule LastCrusader.TokenHandlerTest do
  @moduledoc false

  use ExUnit.Case, async: false
  use Plug.Test
  alias LastCrusader.Cache.MemoryTokenStore, as: MemoryTokenStore

  @opts LastCrusader.Router.init([])

  @client_id "https://webapp.example.org/"
  @redirect_uri "https://webapp.example.org/auth/callback"
  @me "https://some.url.fr/"
  @scope "create"

  @code_verifier "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
  @code_challenge :crypto.hash(:sha256, @code_verifier) |> Base.url_encode64(padding: false)

  defp cache_auth_code(code) do
    MemoryTokenStore.cache({:auth_code, code}, %{
      redirect_uri: @redirect_uri,
      client_id: @client_id,
      me: @me,
      scope: @scope,
      code_challenge: @code_challenge
    })
  end

  describe "POST /token" do
    test "valid code and PKCE returns access_token JSON" do
      cache_auth_code("TOKEN_VALID_CODE")

      conn =
        conn(
          :post,
          "/token?grant_type=authorization_code&code=TOKEN_VALID_CODE&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&code_verifier=#{@code_verifier}"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 200
      {:ok, body} = Jason.decode(conn.resp_body)
      assert body["token_type"] == "Bearer"
      assert body["scope"] == @scope
      assert body["me"] == @me
      assert String.length(body["access_token"]) == 50
      assert body["expires_in"] == 3600
    end

    test "wrong code_verifier returns 400" do
      cache_auth_code("TOKEN_PKCE_FAIL")

      conn =
        conn(
          :post,
          "/token?grant_type=authorization_code&code=TOKEN_PKCE_FAIL&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&code_verifier=WRONG_VERIFIER"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "wrong client_id returns 400" do
      cache_auth_code("TOKEN_CLIENT_FAIL")

      conn =
        conn(
          :post,
          "/token?grant_type=authorization_code&code=TOKEN_CLIENT_FAIL&client_id=https://other.client.com/&redirect_uri=#{@redirect_uri}&code_verifier=#{@code_verifier}"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "wrong redirect_uri returns 400" do
      cache_auth_code("TOKEN_REDIRECT_FAIL")

      conn =
        conn(
          :post,
          "/token?grant_type=authorization_code&code=TOKEN_REDIRECT_FAIL&client_id=#{@client_id}&redirect_uri=https://other.example.com/callback&code_verifier=#{@code_verifier}"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "replaying the same code returns 400 (single-use)" do
      cache_auth_code("TOKEN_SINGLE_USE")

      valid_params =
        "grant_type=authorization_code&code=TOKEN_SINGLE_USE&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&code_verifier=#{@code_verifier}"

      conn1 = conn(:post, "/token?#{valid_params}")
      conn1 = LastCrusader.Router.call(conn1, @opts)
      assert conn1.status == 200

      conn2 = conn(:post, "/token?#{valid_params}")
      conn2 = LastCrusader.Router.call(conn2, @opts)
      assert conn2.status == 400
    end

    test "missing grant_type returns 400" do
      cache_auth_code("TOKEN_NO_GRANT")

      conn =
        conn(
          :post,
          "/token?code=TOKEN_NO_GRANT&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&code_verifier=#{@code_verifier}"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end
  end

  describe "POST /introspect" do
    test "valid token returns active: true with metadata" do
      MemoryTokenStore.cache({:access_token, "INTROSPECT_VALID"}, %{
        me: @me,
        scope: @scope,
        client_id: @client_id,
        issued_at: 0
      })

      conn = conn(:post, "/introspect?token=INTROSPECT_VALID")
      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 200
      {:ok, body} = Jason.decode(conn.resp_body)
      assert body["active"] == true
      assert body["me"] == @me
      assert body["scope"] == @scope
      assert body["client_id"] == @client_id
    end

    test "unknown token returns active: false" do
      conn = conn(:post, "/introspect?token=NO_SUCH_TOKEN")
      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 200
      {:ok, body} = Jason.decode(conn.resp_body)
      assert body["active"] == false
    end
  end

  describe "POST /revoke" do
    test "revokes token so subsequent introspection returns active: false" do
      MemoryTokenStore.cache({:access_token, "REVOKE_ME"}, %{
        me: @me,
        scope: @scope,
        client_id: @client_id,
        issued_at: 0
      })

      revoke_conn = conn(:post, "/revoke?token=REVOKE_ME")
      revoke_conn = LastCrusader.Router.call(revoke_conn, @opts)
      assert revoke_conn.status == 200

      introspect_conn = conn(:post, "/introspect?token=REVOKE_ME")
      introspect_conn = LastCrusader.Router.call(introspect_conn, @opts)
      {:ok, body} = Jason.decode(introspect_conn.resp_body)
      assert body["active"] == false
    end

    test "revoking an unknown token still returns 200" do
      conn = conn(:post, "/revoke?token=NO_SUCH_TOKEN")
      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 200
    end
  end
end
