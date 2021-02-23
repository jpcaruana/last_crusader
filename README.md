[![Build Status](https://travis-ci.com/jpcaruana/last_crusader.svg?branch=master)](https://travis-ci.com/jpcaruana/last_crusader)

# LastCrusader - Indieweb and the Last Crusade

An [Indieweb](https://indieweb.org/) server taylored mainly for _my_ needs, but I hope easily configurable for yours.

- Your content is yours
- You are better connected
- You are in control

Requires at least Elixir 10.0 with OTP 22.0.

Works fine with latest Elixir/OTP.

## Todo

- [ ] [IndieAuth](https://indieauth.com/) server
- [x] [Micropub](https://www.w3.org/TR/micropub/) server
- [ ] [Webmentions](https://indieweb.org/Webmention):
    - [ ] send webmentions
    - [ ] receive webmentions

## Notes to self

- run tests: `mix test`
- run locally: `iex -S mix`
- make a release: `MIX_ENV=prod mix release` or with personal secrets `MIX_ENV=perso mix release`
