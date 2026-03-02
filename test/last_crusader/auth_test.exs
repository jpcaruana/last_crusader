defmodule LastCrusader.AuthTest do
  @moduledoc false

  use ExUnit.Case, async: false
  use Plug.Test
  import LastCrusader.TestHelpers
  alias LastCrusader.Cache.MemoryTokenStore, as: MemoryTokenStore

  @opts LastCrusader.Router.init([])

  @client_id "https://webapp.example.org/"
  @redirect_uri "https://webapp.example.org/auth/callback"
  @me "https://aaronparecki.com/"
  @state "1234567890"
  @issuer "https://some.url.fr"

  # Stable PKCE pair for tests
  @code_verifier "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
  @code_challenge :crypto.hash(:sha256, @code_verifier) |> Base.url_encode64(padding: false)

  describe "GET /auth" do
    test "redirects with code, state, and iss when PKCE params are valid" do
      conn =
        conn(
          :get,
          "/auth?me=#{@me}&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&state=#{@state}&code_challenge=#{@code_challenge}&code_challenge_method=S256"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 302

      [location] = Plug.Conn.get_resp_header(conn, "location")
      uri = URI.parse(location)
      params = URI.decode_query(uri.query)

      assert params["iss"] == @issuer
      assert params["state"] == @state
      assert String.length(params["code"]) == 50
    end

    test "missing code_challenge returns 400" do
      conn =
        conn(
          :get,
          "/auth?me=#{@me}&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&state=#{@state}&code_challenge_method=S256"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "unsupported code_challenge_method returns 400" do
      conn =
        conn(
          :get,
          "/auth?me=#{@me}&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&state=#{@state}&code_challenge=#{@code_challenge}&code_challenge_method=plain"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "me is optional" do
      conn =
        conn(
          :get,
          "/auth?client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&state=#{@state}&code_challenge=#{@code_challenge}&code_challenge_method=S256"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 302
    end

    test "missing client_id returns 400" do
      conn =
        conn(
          :get,
          "/auth?me=#{@me}&redirect_uri=#{@redirect_uri}&state=#{@state}&code_challenge=#{@code_challenge}&code_challenge_method=S256"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "missing redirect_uri returns 400" do
      conn =
        conn(
          :get,
          "/auth?me=#{@me}&client_id=#{@client_id}&state=#{@state}&code_challenge=#{@code_challenge}&code_challenge_method=S256"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end

    test "invalid client_id URL returns 400" do
      conn =
        conn(
          :get,
          "/auth?me=#{@me}&client_id=invalid://webapp.example.org/&redirect_uri=#{@redirect_uri}&state=#{@state}&code_challenge=#{@code_challenge}&code_challenge_method=S256"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 400
    end
  end

  describe "POST /auth" do
    setup do
      MemoryTokenStore.cache({:auth_code, "VALID_CODE"}, %{
        redirect_uri: @redirect_uri,
        client_id: @client_id,
        me: @me,
        scope: "create",
        code_challenge: @code_challenge
      })

      :ok
    end

    test "correct code_verifier returns me in JSON" do
      conn =
        conn(
          :post,
          "/auth?code=VALID_CODE&code_verifier=#{@code_verifier}&redirect_uri=#{@redirect_uri}&client_id=#{@client_id}"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 200
      assert conn.resp_body == ~s({"me":"#{@me}"})

      assert Plug.Conn.get_resp_header(conn, "content-type") == [
               "application/json; charset=utf-8"
             ]
    end

    test "wrong code_verifier returns 401" do
      conn =
        conn(
          :post,
          "/auth?code=VALID_CODE&code_verifier=WRONG_VERIFIER&redirect_uri=#{@redirect_uri}&client_id=#{@client_id}"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 401
    end

    test "code is single-use: replaying returns 401" do
      MemoryTokenStore.cache({:auth_code, "SINGLE_USE_CODE"}, %{
        redirect_uri: @redirect_uri,
        client_id: @client_id,
        me: @me,
        scope: "create",
        code_challenge: @code_challenge
      })

      conn1 =
        conn(
          :post,
          "/auth?code=SINGLE_USE_CODE&code_verifier=#{@code_verifier}"
        )

      conn1 = LastCrusader.Router.call(conn1, @opts)
      assert conn1.status == 200

      wait_for_deletion({:auth_code, "SINGLE_USE_CODE"})

      conn2 =
        conn(
          :post,
          "/auth?code=SINGLE_USE_CODE&code_verifier=#{@code_verifier}"
        )

      conn2 = LastCrusader.Router.call(conn2, @opts)
      assert conn2.status == 401
    end

    test "bad token returns 401" do
      conn =
        conn(
          :post,
          "/auth?code=BAD_TOKEN&code_verifier=#{@code_verifier}"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 401
    end

    test "cache miss returns 401" do
      conn =
        conn(
          :post,
          "/auth?code=NO_SUCH_CODE&code_verifier=any_verifier"
        )

      conn = LastCrusader.Router.call(conn, @opts)

      assert conn.status == 401
    end
  end
end
