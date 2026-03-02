# `LastCrusader.Auth.TokenHandler`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/auth/token_handler.ex#L1)

IndieAuth token, introspection, and revocation endpoints.

see https://indieauth.spec.indieweb.org/#token-endpoint

# `introspect`

POST /introspect — inspect an access token.

Parameter:
- `token` (required): The access token to inspect.

Returns `{active: true, me, scope, client_id}` for a valid token, or
`{active: false}` for an unknown/expired token. Always returns 200.

# `issue_token`

POST /token — exchange an auth code for an access token.

Parameters:
- `grant_type` (required): Must be "authorization_code".
- `code` (required): The auth code from the authorization endpoint.
- `client_id` (required): Must match the client_id used to obtain the code.
- `redirect_uri` (required): Must match the redirect_uri used to obtain the code.
- `code_verifier` (required): PKCE code verifier.

Returns JSON: `{access_token, token_type, scope, me, expires_in}`.
Codes are single-use.

# `revoke`

POST /revoke — revoke an access token.

Parameter:
- `token` (required): The access token to revoke.

Always returns 200 per RFC 7009, even for unknown tokens.

---

*Consult [api-reference.md](api-reference.md) for complete listing*
