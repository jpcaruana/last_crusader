# LastCrusader

Elixir IndieWeb server (Plug + Bandit). Handles IndieAuth, Micropub (publish posts), Webmentions, and comments. Posts are committed as Hugo TOML+Markdown files to GitHub and syndicated to Mastodon, Bluesky, and Twitter.

Mostly a [Micropub](https://www.w3.org/TR/micropub/) endpoint.

## Commands

```bash
mix test                          # all tests
mix test path/to/test.exs         # single test file
mix test path/to/test.exs:42      # single test by line
mix format                        # format code
mix check                         # credo + doctor + format + tests
mix credo                         # lint
iex -S mix                        # interactive dev server
MIX_ENV=perso mix release         # personal release
```

## Architecture

```
Router
├── AuthHandler       — IndieAuth
└── MicropubHandler   — Micropub
        └── Micropub (core logic)
                ├── PostTypeDiscovery
                ├── Hugo             — generates TOML+Markdown files
                └── GitHub           — commits/pushes posts

WebmentionsSender    — async, scheduled
MemoryTokenStore     — in-memory token cache
```

HTTP client: Tesla, with mock adapter in test/dev environments.

`config/perso.exs` — personal environment with real credentials (not committed).

## Conventions

- Tests use `async: true` by default
- HTTP mocking via `Tesla.Mock`
- Git hooks: pre-commit runs `mix format`, pre-push runs `mix check`
