defmodule LastCrusader.Auth.TokenHandler do
  @moduledoc """
  IndieAuth token, introspection, and revocation endpoints.

  see https://indieauth.spec.indieweb.org/#token-endpoint
  """
  import Plug.Conn

  alias Jason, as: Json
  alias LastCrusader.Cache.MemoryTokenStore, as: TokenStore
  alias LastCrusader.Utils.Randomizer, as: Randomizer

  @doc """
  POST /token — exchange an auth code for an access token.

  Parameters:
  - `grant_type` (required): Must be "authorization_code".
  - `code` (required): The auth code from the authorization endpoint.
  - `client_id` (required): Must match the client_id used to obtain the code.
  - `redirect_uri` (required): Must match the redirect_uri used to obtain the code.
  - `code_verifier` (required): PKCE code verifier.

  Returns JSON: `{access_token, token_type, scope, me, expires_in}`.
  Codes are single-use.
  """
  def issue_token(conn) do
    grant_type = conn.params["grant_type"]
    code = conn.params["code"]
    client_id = conn.params["client_id"]
    redirect_uri = conn.params["redirect_uri"]
    code_verifier = conn.params["code_verifier"]

    case validate_token_request(grant_type, code, client_id, redirect_uri, code_verifier) do
      {:ok, auth_data} ->
        TokenStore.delete({:auth_code, code})
        access_token = Randomizer.randomizer(50)

        TokenStore.cache({:access_token, access_token}, %{
          me: auth_data.me,
          scope: auth_data.scope,
          client_id: client_id,
          issued_at: System.system_time(:second)
        })

        response = %{
          access_token: access_token,
          token_type: "Bearer",
          scope: auth_data.scope,
          me: auth_data.me,
          expires_in: 3600
        }

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Json.encode!(response))

      {:error, _reason} ->
        send_resp(conn, 400, "Bad Request")
    end
  end

  @doc """
  POST /introspect — inspect an access token.

  Parameter:
  - `token` (required): The access token to inspect.

  Returns `{active: true, me, scope, client_id}` for a valid token, or
  `{active: false}` for an unknown/expired token. Always returns 200.
  """
  def introspect(conn) do
    token = conn.params["token"]

    response =
      case TokenStore.read({:access_token, token}) do
        %{me: me, scope: scope, client_id: client_id} ->
          %{active: true, me: me, scope: scope, client_id: client_id}

        _ ->
          %{active: false}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Json.encode!(response))
  end

  @doc """
  POST /revoke — revoke an access token.

  Parameter:
  - `token` (required): The access token to revoke.

  Always returns 200 per RFC 7009, even for unknown tokens.
  """
  def revoke(conn) do
    token = conn.params["token"]
    TokenStore.delete({:access_token, token})
    send_resp(conn, 200, "")
  end

  defp validate_token_request("authorization_code", code, client_id, redirect_uri, code_verifier) do
    with %{client_id: ^client_id, redirect_uri: ^redirect_uri, code_challenge: code_challenge} =
           auth_data <- TokenStore.read({:auth_code, code}),
         true <- pkce_valid?(code_verifier, code_challenge) do
      {:ok, auth_data}
    else
      _ -> {:error, :invalid_request}
    end
  end

  defp validate_token_request(_, _, _, _, _), do: {:error, :invalid_grant_type}

  defp pkce_valid?(nil, _), do: false

  defp pkce_valid?(code_verifier, code_challenge) do
    computed = :crypto.hash(:sha256, code_verifier) |> Base.url_encode64(padding: false)
    computed == code_challenge
  end
end
