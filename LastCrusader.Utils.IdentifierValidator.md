# `LastCrusader.Utils.IdentifierValidator`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/utils/identifier_validator.ex#L1)

Indie Auth Identifier Validator

see spec https://indieauth.spec.indieweb.org/#user-profile-url

## User Profile URL

Users are identified by a [URL]. Profile URLs MUST have either an https or http scheme, MUST contain a path component (/ is a valid path), MUST NOT contain single-dot or double-dot path segments, MAY contain a query string component, MUST NOT contain a fragment component, MUST NOT contain a username or password component, and MUST NOT contain a port. Additionally, hostnames MUST be domain names and MUST NOT be ipv4 or ipv6 addresses.

Some examples of valid profile URLs are:

    https://example.com/
    https://example.com/username
    https://example.com/users?id=100

Some examples of invalid profile URLs are:

    example.com - missing scheme
    mailto:user@example.com - invalid scheme
    https://example.com/foo/../bar - contains a double-dot path segment
    https://example.com/#me - contains a fragment
    https://user:pass@example.com/ - contains a username and password
    https://example.com:8443/ - contains a port
    https://172.28.92.51/ - host is an IP address

# `url`

```elixir
@type url() :: String.t()
```

# `validate_user_profile_url`

```elixir
@spec validate_user_profile_url(url()) :: :invalid | :valid
```

  Validates a user profile URL according to the IndieAuth spec

# `validate_user_profile_url`

```elixir
@spec validate_user_profile_url(:invalid | :valid, url()) :: :invalid | :valid
```

  Validates a user profile URL according to the IndieAuth spec

  Useful in a validation pipe, but really relies on `validate_user_profile_url/1`

---

*Consult [api-reference.md](api-reference.md) for complete listing*
