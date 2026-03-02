# `LastCrusader.Auth.AuthHandler`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/auth/auth_handler.ex#L1)

IndieAuth authorization endpoint

An authorization endpoint is an HTTP endpoint that micropub and IndieAuth clients
can use to identify a user or obtain an authorization code (which is then later
exchanged for an access token) to be able to post to their website.

Supports PKCE (S256 only) as required by the current IndieAuth spec.

see https://indieauth.spec.indieweb.org/#authorization-endpoint

# `auth_endpoint`

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

# `code_verification`

POST /auth — profile-only auth code verification.

The client submits the auth code along with a `code_verifier` to prove possession
of the original PKCE secret. On success, returns `{"me": "<user_url>"}`.

Parameters:
- `code` (required): The auth code received in the redirect.
- `code_verifier` (required): The PKCE code verifier (pre-hash plaintext).

Codes are single-use: a successful verification deletes the code from the cache.

---

*Consult [api-reference.md](api-reference.md) for complete listing*
