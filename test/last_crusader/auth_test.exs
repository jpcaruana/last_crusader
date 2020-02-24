defmodule LastCrusader.AuthTest do
  @moduledoc """
  Unit tests for IndieAuth: authorization-endpoint

  see https://indieweb.org/authorization-endpoint

  Parameters:

  me
    Full URI of the user's homepage
  client_id
    Full URI of the application's/website's home page. Used to identify the application. An authorization endpoint may show the application's icon and title to the user during the auth process.
  redirect_uri
    Full URI to redirect back to when the login process is finished
  state
    A random value the app makes up, unique per request. The authorization server just passes it back to the app.
    Optional. Auth endpoints MUST support them, though.
  response_type
    id (identification only) or code (identification + authorization)
    Optional. Defaults to id.
  scope
    Not used and omitted in identification mode (response_type=id)
    For authorization, the scope contains a space-separated lis of scopes that the web application requests permission for, e.g. "create". Multiple values are supported, e.g. create delete
  """

  use ExUnit.Case, async: true
  use Plug.Test

  @opts LastCrusader.Router.init([])

  test "auth should redirect to web application" do
    conn = conn(
      :get,
      "/auth?me=https://aaronparecki.com/&client_id=https://webapp.example.org/&redirect_uri=https://webapp.example.org/auth/callback&state=1234567890&response_type=id"
    )

    # Invoke the plug
    conn = LastCrusader.Router.call(conn, @opts)

    # Assert the response and status
    assert_redirect(conn, 301, "https://webapp.example.org/auth/callback?code=xxxxxxxx&state=1234567890")
  end

  defp assert_redirect(conn, code, to) do
    assert conn.state == :sent
    assert conn.status == code
    assert Plug.Conn.get_resp_header(conn, "location") == [to]
  end
end
