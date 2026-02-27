defmodule LastCrusader.Auth.MetadataHandler do
  @moduledoc """
  IndieAuth authorization server metadata endpoint.

  Returns server capability metadata per RFC 8414 and the IndieAuth spec.

  see https://indieauth.spec.indieweb.org/#indieauth-server-metadata
  """
  import Plug.Conn

  alias Jason, as: Json

  @doc """
  GET /.well-known/oauth-authorization-server — authorization server metadata.

  Returns a JSON document describing the server's endpoints and supported features.
  All endpoint URLs are derived from the configured `issuer`.
  """
  def metadata(conn) do
    issuer = Application.get_env(:last_crusader, :issuer)

    response = %{
      issuer: issuer,
      authorization_endpoint: "#{issuer}/auth",
      token_endpoint: "#{issuer}/token",
      introspection_endpoint: "#{issuer}/introspect",
      revocation_endpoint: "#{issuer}/revoke",
      code_challenge_methods_supported: ["S256"],
      scopes_supported: ["profile", "create", "update", "delete", "media"]
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Json.encode!(response))
  end
end
