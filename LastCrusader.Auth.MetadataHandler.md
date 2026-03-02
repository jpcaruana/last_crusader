# `LastCrusader.Auth.MetadataHandler`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/auth/metadata_handler.ex#L1)

IndieAuth authorization server metadata endpoint.

Returns server capability metadata per RFC 8414 and the IndieAuth spec.

see https://indieauth.spec.indieweb.org/#indieauth-server-metadata

# `metadata`

GET /.well-known/oauth-authorization-server — authorization server metadata.

Returns a JSON document describing the server's endpoints and supported features.
All endpoint URLs are derived from the configured `issuer`.

---

*Consult [api-reference.md](api-reference.md) for complete listing*
