defmodule LastCrusader.Auth do
  @moduledoc """
  Handles HTTP requests for IndieAuth

  see https://indieweb.org/authorization-endpoint
  """
  import Plug.Conn

  @doc """
  IndieAuth: authorization-endpoint

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
    For authorization, the scope contains a space-separated list of scopes that the web application requests permission for, e.g. "create". Multiple values are supported, e.g. create delete
  """
  def auth_endpoint(conn) do
    q = fetch_query_params(conn)
    redirect_uri = q.query_params["redirect_uri"]
    state = q.query_params["state"]
    me = q.query_params["me"]
    client_id = q.query_params["client_id"]

    token = Randomizer.randomizer(50)
    RequestCache.cache({redirect_uri, client_id}, {token, me})

    conn = put_headers(conn, %{location: "#{redirect_uri}?code=#{token}&state=#{state}"})

    send_resp(conn, 301, "")
  end

  @doc """
  Auth code verification

  For the sign-in flow, the web application will query the authorization endpoint to verify the auth code it received. The client makes a POST request to the authorization server with the following values:

  POST https://auth.example.org/auth
  Content-type: application/x-www-form-urlencoded

  code=xxxxxxxx
  &redirect_uri=https://webapp.example.org/auth/callback
  &client_id=https://webapp.example.org/

  After the authorization server verifies that redirect_uri, client_id match the code given, the response will include the "me" value indicating the URL of the user who signed in. The response content-type should be either application/x-www-form-urlencoded or application/json depending on the value of the HTTP Accept header.

  Parameters:

  me
    Full URI of the user's homepage
    This may be different from the me parameter that the user originally entered, but MUST be on the same domain.
  """
  def code_verification(conn) do
    q = fetch_query_params(conn)
    redirect_uri = q.query_params["redirect_uri"]
    client_id = q.query_params["client_id"]
    token = q.query_params["code"]

    case RequestCache.read({redirect_uri, client_id}) do
      {^token, me} -> send_resp(conn, 200, me)
      _ -> send_resp(conn, 401, "Unauthorized")
    end
  end

  defp put_headers(conn, key_values) do
    Enum.reduce key_values, conn, fn {k, v}, conn ->
      put_resp_header(conn, to_string(k), v)
    end
  end
end
