# LastCrusader - Indieweb and the Last Crusade

An [Indieweb](https://indieweb.org/) server taylored mainly for _my_ needs, but I hope easily configurable for yours.

- Your content is yours
- You are better connected
- You are in control

Requires at least Elixir 14.0 with OTP 24.

Works fine with latest Elixir/OTP

## Todo

- [ ] [IndieAuth](https://indieauth.com/) endpoint
- [X] [Micropub](https://www.w3.org/TR/micropub/) endpoint
  - [ ] [Webmentions](https://indieweb.org/Webmention):
      - [X] send webmentions on new posts
      - [ ] receive webmentions
- [X] Comment API

## Notes to self

- run tests: `mix test`
- run locally: `iex -S mix`
- install git hooks locally: `mix git_hooks.install`
- make a release: `MIX_ENV=prod mix release` or with personal secrets `MIX_ENV=perso mix release`
- make a release that targets a debian: `./debian_release.sh` (uses docker)
