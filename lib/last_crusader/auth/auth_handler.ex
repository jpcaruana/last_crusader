defmodule LastCrusader.Auth.AuthHandler do
  @moduledoc """
  IndieAuth authorization endpoint

  An authorization endpoint is an HTTP endpoint that micropub and IndieAuth clients
  can use to identify a user or obtain an authorization code (which is then later
  exchanged for an access token) to be able to post to their website.

  Supports PKCE (S256 only) as required by the current IndieAuth spec.

  see https://indieauth.spec.indieweb.org/#authorization-endpoint
  """
  import Plug.Conn

  alias Jason, as: Json
  alias LastCrusader.Cache.MemoryTokenStore, as: TokenStore
  alias LastCrusader.Utils.Randomizer, as: Randomizer
  alias LastCrusader.Utils.Http, as: Utils
  alias LastCrusader.Utils.IdentifierValidator, as: Validator

  @doc """
  GET /auth — authorization endpoint.

  Starts the IndieAuth sign-in flow. The user's browser is redirected here with
  the following query parameters:

  - `client_id` (required): Full URI of the application's home page.
  - `redirect_uri` (required): Full URI to redirect to when the auth process is done.
  - `state` (optional): Opaque value passed through unchanged.
  - `me` (optional): Hint at the user's profile URL; no longer validated.
  - `scope` (optional): Space-separated list of requested scopes.
  - `code_challenge` (required): PKCE code challenge (Base64URL(SHA256(verifier))).
  - `code_challenge_method` (optional): Must be "S256" if present; defaults to S256.

  On success, redirects to `redirect_uri?code=<code>&state=<state>&iss=<issuer>`.
  """
  def auth_endpoint(conn) do
    redirect_uri = conn.params["redirect_uri"]
    state = conn.params["state"]
    me = conn.params["me"]
    client_id = conn.params["client_id"]
    scope = conn.params["scope"]
    code_challenge = conn.params["code_challenge"]
    code_challenge_method = conn.params["code_challenge_method"]

    {status, body, headers} =
      cond do
        not is_nil(code_challenge_method) and code_challenge_method != "S256" ->
          {400, "", nil}

        is_nil(code_challenge) ->
          {400, "", nil}

        Validator.validate_user_profile_url(client_id) == :invalid ->
          {400, "", nil}

        Validator.validate_user_profile_url(redirect_uri) == :invalid ->
          {400, "", nil}

        true ->
          generate_auth_code(redirect_uri, client_id, me, state, scope, code_challenge)
      end

    conn
    |> Utils.put_headers(headers)
    |> send_resp(status, body)
  end

  defp generate_auth_code(redirect_uri, client_id, me, state, scope, code_challenge) do
    token = Randomizer.randomizer(50)
    issuer = Application.get_env(:last_crusader, :issuer)

    TokenStore.cache({:auth_code, token}, %{
      redirect_uri: redirect_uri,
      client_id: client_id,
      me: me,
      scope: scope,
      code_challenge: code_challenge
    })

    query = URI.encode_query(%{"code" => token, "state" => state, "iss" => issuer})
    {302, "", %{location: "#{redirect_uri}?#{query}"}}
  end

  @doc """
  POST /auth — profile-only auth code verification.

  The client submits the auth code along with a `code_verifier` to prove possession
  of the original PKCE secret. On success, returns `{"me": "<user_url>"}`.

  Parameters:
  - `code` (required): The auth code received in the redirect.
  - `code_verifier` (required): The PKCE code verifier (pre-hash plaintext).

  Codes are single-use: a successful verification deletes the code from the cache.
  """
  def code_verification(conn) do
    code = conn.params["code"]
    code_verifier = conn.params["code_verifier"]

    case TokenStore.read({:auth_code, code}) do
      %{me: me, code_challenge: code_challenge} ->
        if pkce_valid?(code_verifier, code_challenge) do
          TokenStore.delete({:auth_code, code})

          conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Json.encode!(%{me: me}))
        else
          send_resp(conn, 401, "Unauthorized")
        end

      _ ->
        send_resp(conn, 401, "Unauthorized")
    end
  end

  defp pkce_valid?(nil, _), do: false

  defp pkce_valid?(code_verifier, code_challenge) do
    computed = :crypto.hash(:sha256, code_verifier) |> Base.url_encode64(padding: false)
    computed == code_challenge
  end
end
