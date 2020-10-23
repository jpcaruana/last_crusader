defmodule LastCrusader.Auth.CheckAuthorizationCode do
  @moduledoc """
  Verifying the Indieweb [Authorization Code](https://indieweb.org/authorization-endpoint#Auth_code_verification).
  This is dedicated [Plug](https://elixirschool.com/en/lessons/specifics/plug/#adding-another-plug).

  see https://indieweb.org/obtaining-an-access-token and https://indieweb.org/token-endpoint#Verifying_an_Access_Token

  A micropub endpoint will make a request to the token endpoint to verify that an incoming access token is valid.

  The URL of the token server must be known to the micropub endpoint in advance.
  The bearer token does not contain any information about the server address.

  This means that the micropub endpoint dictates the token endpoint that the user links to on his homepage.

  The micropub endpoint will make a request like the following:

      GET https://tokens.indieauth.com/token
      Authorization: Bearer xxxxxxxx

  The token endpoint looks at the token in the authorization header and verifies it.
  How exactly it does this is up to the implementation, such as in the example below of using either a self-encoded token or a database of tokens.
  After verifying the token is still valid, the token endpoint returns the information about the token such as
  the user and scope, in form-encoded or JSON format depending on the HTTP Accept header:

      HTTP/1.1 200 OK
      Content-Type: application/x-www-form-urlencoded

      me=https://aaronparecki.com/&
      client_id=https://ownyourgram.com/&
      scope=create update

  as json:

      HTTP/1.1 200 OK
      Content-Type: application/json

      {
        "me": "https://aaronparecki.com/",
        "client_id": "https://ownyourgram.com/",
        "scope": "create update"
      }

  The micropub endpoint will then inspect these values and determine whether to proceed with the request.
  """

  defmodule BadAuthorizationCodeError do
    @moduledoc """
    Error raised when a the [Authorization Code](https://indieweb.org/authorization-endpoint#Auth_code_verification) is wrong
    """

    defexception message: "Failing to verify Authorization Code", plug_status: 401
  end

  @doc false
  def init(options), do: options

  @doc false
  def call(%Plug.Conn{request_path: path} = conn, opts) do
    if path in opts[:paths] do
      check_auth_code!(conn.params, opts[:fields], nil, nil, nil)
    end

    conn
  end

  defp check_auth_code!(token_endpoint, token, me, client_id, scope) do
    # HTTP POST to token_endpoint: token-> me, client_id, scope
    valid = true

    unless valid, do: raise(BadAuthorizationCodeError)
  end

end
