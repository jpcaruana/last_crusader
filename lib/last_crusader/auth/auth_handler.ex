defmodule LastCrusader.Auth.AuthHandler do
  @moduledoc """
  IndieAuth authorization endpoint

   An authorization endpoint is an HTTP endpoint that micropub and IndieAuth clients can use to identify a user or obtain an authorization code (which is then later exchanged for an access token) to be able to post to their website.

  see https://indieweb.org/authorization-endpoint
  """
  import Plug.Conn

  alias Jason, as: Json
  alias LastCrusader.Cache.MemoryTokenStore, as: TokenStore
  alias LastCrusader.Utils.Randomizer, as: Randomizer
  alias LastCrusader.Utils.Http, as: Utils
  alias LastCrusader.Utils.IdentifierValidator, as: Validator

  @doc """
  authorization-endpoint. To start the sign-in flow, the user's browser will be redirected to their authorization endpoint, with additional parameters in the query string.

  ## Parameters:

  - me:
    Full URI of the user's homepage
  - client_id:
    Full URI of the application's/website's home page. Used to identify the application. An authorization endpoint may show the application's icon and title to the user during the auth process.
  - redirect_uri:
    Full URI to redirect back to when the login process is finished
  - state:
    A random value the app makes up, unique per request. The authorization server just passes it back to the app.
    Optional. Auth endpoints MUST support them, though.
  - response_type:
    id (identification only) or code (identification + authorization)
    Optional. Defaults to id.
  - scope:
    Not used and omitted in identification mode (response_type=id)
    For authorization, the scope contains a space-separated list of scopes that the web application requests permission for, e.g. "create". Multiple values are supported, e.g. create delete
  """
  def auth_endpoint(conn) do
    redirect_uri = conn.params["redirect_uri"]
    state = conn.params["state"]
    me = conn.params["me"]
    client_id = conn.params["client_id"]

    {status, body, headers} =
      case Validator.validate_user_profile_url(client_id)
           |> Validator.validate_user_profile_url(redirect_uri)
           |> Validator.validate_user_profile_url(me) do
        :invalid -> {400, "", nil}
        _ -> generate_token(redirect_uri, client_id, me, state)
      end

    conn
    |> Utils.put_headers(headers)
    |> send_resp(status, body)
  end

  defp generate_token(redirect_uri, client_id, me, state) do
    token = Randomizer.randomizer(50)
    TokenStore.cache({redirect_uri, client_id}, {token, me})

    {302, "", %{location: "#{redirect_uri}?code=#{token}&state=#{state}"}}
  end

  @doc """
  Auth code verification

  For the sign-in flow, the web application will query the authorization endpoint to verify the auth code it received. The client makes a POST request to the authorization server with the following values:

  ```
  POST https://auth.example.org/auth
  Content-type: application/x-www-form-urlencoded

  code=xxxxxxxx
  &redirect_uri=https://webapp.example.org/auth/callback
  &client_id=https://webapp.example.org/
  ```

  After the authorization server verifies that redirect_uri, client_id match the code given, the response will include the "me" value indicating the URL of the user who signed in. The response content-type should be either application/x-www-form-urlencoded or application/json depending on the value of the HTTP Accept header.

  ## Parameters:

  - me:
    Full URI of the user's homepage
    This may be different from the me parameter that the user originally entered, but MUST be on the same domain.
  """
  def code_verification(conn) do
    redirect_uri = conn.params["redirect_uri"]
    client_id = conn.params["client_id"]
    token = conn.params["code"]

    case TokenStore.read({redirect_uri, client_id}) do
      {^token, me} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Json.encode!(%{me: me}))

      _ ->
        send_resp(conn, 401, "Unauthorized")
    end
  end
end
