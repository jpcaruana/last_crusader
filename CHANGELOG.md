# Changelog

## 0.11.x
### 0.11.0
2024/02/15
- hugo syndication:
    - send webmentions for bluesky silo
- Elixir 1.16 and OTP 26 compatibility
- dependencies update:
    - #174/#176/#178/#189/#193/#195: [bump bandit from 0.7.7 to 1.2.0](https://github.com/jpcaruana/last_crusader/pull/195)
    - #179/#180/#181/#182/#184: [bump sentry from 9.1.0 to 10.1.0](https://github.com/jpcaruana/last_crusader/pull/184)
    - #186: [bump mint from 1.5.1 to 1.5.2](https://github.com/jpcaruana/last_crusader/pull/186)
    - #177/#194: [bump plug from 1.15.1 to 1.15.3](https://github.com/jpcaruana/last_crusader/pull/194)

## 0.10.x
### 0.10.4
2023/10/17
- unit tests: logger config for tests: always evaluate all logs to prevent bad formatted logs to crash production
- refactor: do not use (long) deprecated Mix.Config
- enable `Plug.RequestId` module
- loggers: :console backend configuration is automatically maped to the default handler and default formatter
- dependencies update:
    - #165: [bump sentry from 8.1.0 to 9.1.0](https://github.com/jpcaruana/last_crusader/pull/165) and upgrade related config
    - #164: [bump castore from 1.0.3 to 1.0.4](https://github.com/jpcaruana/last_crusader/pull/164)
    - #158/##160/#168/#170: [bump hackney from 1.18.1 to 1.20.0](https://github.com/jpcaruana/last_crusader/pull/170)
    - #162/#166: [bump plug from 1.14.2 to 1.15.1](https://github.com/jpcaruana/last_crusader/pull/162)

### 0.10.3
2023/08/08
- dependencie update: #152: [bump castore from 0.1.22 to 1.0.3](https://github.com/jpcaruana/last_crusader/pull/152)

### 0.10.2
2023/08/07
- webmention scheduling: use `Task.Supervisor.async_nolink/3` for a better async job handling
- webmention: added more logs for more context
- use Elixir's `Process.sleep/1` instead of erlang's `:timer.sleep`

### 0.10.1
2023/08/07
- [#149](https://github.com/jpcaruana/last_crusader/pull/149) upgrade broken Webmentions dependancy
	- webmentions 3.0.0 => 3.0.1
	- tesla 1.4.4 => 1.7.0
	- floki 0.34.2 => 0.34.3
- dependencies update:
    - #142: [bump sentry from 8.0.6 to 8.1.0](https://github.com/jpcaruana/last_crusader/pull/142)
    - #139: [bump jason from 1.4.0 to 1.4.1](https://github.com/jpcaruana/last_crusader/pull/139)
    - #133/#137: [bump tz from 0.24.0 to 0.26.2](https://github.com/jpcaruana/last_crusader/pull/137)
    - #122#124/#134/#135/#136: [bump bandit from 0.6.9 to 0.7.7](https://github.com/jpcaruana/last_crusader/pull/136)
    - #125: [bump plug from 1.14.0 to 1.14.1](https://github.com/jpcaruana/last_crusader/pull/125)
    - #121: [bump mint from 1.5.0 to 1.5.1](https://github.com/jpcaruana/last_crusader/pull/121)
		- also manually bumped the following deps:
			- earmark_parser 1.4.30 => 1.4.31
			- floki 0.34.0 => 0.34.2

### 0.10.0
2023/03/03: Bandit edition
- [#119](https://github.com/jpcaruana/last_crusader/pull/119): webserver: move from [Cowboy](https://github.com/ninenines/cowboy) to [Bandit](https://github.com/mtrudel/bandit), based on [Thousand Island](https://github.com/mtrudel/thousand_island). Bandit is a pure Elixir HTTP server for Plug & WebSock applications 
- dependencies update:
    - #117: [bump mint from 1.4.2 to 1.5.0](https://github.com/jpcaruana/last_crusader/pull/117)
    - removed Cowboy deps

## 0.9.x
### 0.9.11
2023/01/23
- comment API: allow http OPTIONS requests
- dependencies update:
    - #108/#113/#116: [bump castore from 0.1.18 to 0.1.22](https://github.com/jpcaruana/last_crusader/pull/116)
    - bump telemetry from 1.1.0 to 1.2.1

### 0.9.10
2022/11/11
- syndication links: dedicated silo keywords (like twitter, mastodon) to display syndication to several studios for one note/post

### 0.9.9
2022/11/10
- simplify webmention links detection: not done by hand, extracted from the published page

### 0.9.8
2022/11/10
- hugo: link extraction for webmentions: always include https://fed.brid.gy/
- dependencies update:
    - #106: [bump tz from 0.23.0 to 0.24.0](https://github.com/jpcaruana/last_crusader/pull/106)

### 0.9.7
2022/11/09: 1st mastodon edition
- hugo syndication:
    - send webmentions for mastodon silo (should be a parameter)
    - a post can syndicate to several silos (e.g. twitter _and_ mastodon)
    - send webmentions for `like_of` posts
- dependencies update:
    - #105: [bump plug_cowboy from 2.5.2 to 2.6.0](https://github.com/jpcaruana/last_crusader/pull/105)
    - #106: [bump tz from 0.22.0 to 0.23.0](https://github.com/jpcaruana/last_crusader/pull/106)
    - floki 0.33.1 => 0.34.0

### 0.9.6
2022/10/21
- fix elixir 1.14: use `Application.compile_env/3` instead of `Application.get_env/3`
- dependencies update:
    - #100: [bump jason from 1.3.0 to 1.4.0](https://github.com/jpcaruana/last_crusader/pull/100)
    - earmark_parser 1.4.28 => 1.4.29
    - mime 2.0.2 => 2.0.3
    - plug_crypto 1.2.2 => 1.2.3

### 0.9.5
2022/09/02
- Micropub: Hugo: accept `listen-of` notes
- dependencies update:
    - #96: [bump castore from 0.1.17 to 0.1.18](https://github.com/jpcaruana/last_crusader/pull/96)
    - #98: [bump tz from 0.21.1 to 0.22.0](https://github.com/jpcaruana/last_crusader/pull/98)
        - hpax: 0.1.1 -> 0.1.2

### 0.9.4
2022/07/29
- comments API:
	- accept JSON and url-formencoded requests
	- fix confusion in Map with atoms and string for keys / avoid getting atoms from the outside

### 0.9.1
2022/07/28
- dependencies update:
    - bump earmark_parser from 1.4.25 to 1.4.26
    - bump floki from 0.32.0 to 0.33.1 (minor)
    - bump plug from 1.13.4 to 1.13.6
    - bump telemetry from 1.0.0 to 1.1.0
    - #92/#93: [bump tz from 0.20.1 to 0.21.1](https://github.com/jpcaruana/last_crusader/pull/92)
    - #89: [bump mint from 1.4.1 to 1.4.2](https://github.com/jpcaruana/last_crusader/pull/89)
    - #86: [bump castore from 0.1.16 to 0.1.17](https://github.com/jpcaruana/last_crusader/pull/86)

### 0.9.0
2022/03/25: comment API edition
- new comments API, see `LastCrusader.Micropub.MicropubHandler.comment/1`
- dependencies update:
    - #82: [bump castore from 0.1.15 to 0.1.16](https://github.com/jpcaruana/last_crusader/pull/82)

## 0.8.x
### 0.8.2
2022/03/17
- micropub: `q=category`: returns an ordered list of (weighted) tags from your website
- log server port on application start
- dependencies update:
    - bump plug from 1.12.1 to 1.13.4
    - bump makeup_elixir from 0.15.2 to 0.16.0
    - bump earmark_parser from 1.4.20 to 1.4.23

### 0.8.1
2022/03/10
- micropub: `q=syndicate-to`: return syndication links
- micropub: github: fix reverse URL guessing

### 0.8.0
2022/03/09
- micropub: Hugo: generate files as [Pages Bundles](https://gohugo.io/content-management/page-bundles/)
    - as a preparation for welcoming comments in addition to webmentions
- micropub: Hugo: remove randomness from filename generation (use EPOCH seconds)
- dependencies update:
    - #81: [bump nimble_parsec from 1.2.2 to 1.2.3](https://github.com/jpcaruana/last_crusader/pull/81)
    - #79: [bump webmentions from 2.0.0 to 3.0.0](https://github.com/jpcaruana/last_crusader/pull/79)

## 0.7.x
### 0.7.6
2022/02/25
- micropub: Hugo: avoid markdown 'quote' char (`>`) for filename generation
- dependencies update:
    - #74: [bump mint from 1.4.0 to 1.4.1](https://github.com/jpcaruana/last_crusader/pull/74)
        - added dep on hpax 0.1.1

### 0.7.5
2022/02/15
- micropub: Hugo: avoid hugo shortcode for twitter user for filename generation
- dependencies update:
    - #71: [bump hackney from 1.18.0 to 1.18.1](https://github.com/jpcaruana/last_crusader/pull/71)
        - certify: 2.8.0 -> 2.9.0
    - #72: [bump nimble_parsec from 1.2.1 to 1.2.2](https://github.com/jpcaruana/last_crusader/pull/72)

### 0.7.4
2022/02/02
- dependencies update:
    - #69: [bump castore from 0.1.14 to 0.1.15](https://github.com/jpcaruana/last_crusader/pull/69)
    - #67: [bump nimble_parsec from 1.2.0 to 1.2.1](https://github.com/jpcaruana/last_crusader/pull/67)

### 0.7.3
2022/01/20
- webapp: add `Plug.Cowboy.Drainer` for a cleaner shutdown
- debug mode: webmention sender: more logs
- dependencies update:
    - #62: [bump webmentions from 1.0.3 to 2.0.0](https://github.com/jpcaruana/last_crusader/pull/62)
        - floki: 0.31.0 -> 0.32.0

### 0.7.2
2021/12/22
- parse links from markdown: use [nimble parsec](https://hexdocs.pm/nimble_parsec/) instead of regex
    - Note: it adds a new dependency to this (great) library
- dependencies update:
    - #59: [bump castore from 0.1.13 to 0.1.14](https://github.com/jpcaruana/last_crusader/pull/59)
    - #60: [bump tesla from 1.4.3 to 1.4.4](https://github.com/jpcaruana/last_crusader/pull/60)
        - mime: 1.6.0 -> 2.0.2
    - #61: [bump jason from 1.2.2 to 1.3.0](https://github.com/jpcaruana/last_crusader/pull/61)

### 0.7.1
2021/12/03
- micropub: fix date conversion to Hugo (respect the timezone)
    - removed compatibility with Elixir < 1.12
- fix sentry necessary dependencies and install
- dependencies update:
    - #50/#55: [bump bump castore from 0.1.11 to 0.1.13](https://github.com/jpcaruana/last_crusader/pull/55)
    - #49: [bump sentry from 8.0.5 to 8.0.6](https://github.com/jpcaruana/last_crusader/pull/49)
        - certifi: 2.6.1 -> 2.8.0
        - hackney: 1.17.4 -> 1.18.0

### 0.7.0
2021/09/24
- added [sentry](https://sentry.io/) monitoring
- dependencies update:
    - #40/#47: [bump tz from 0.19.0 to 0.20.1](https://github.com/jpcaruana/last_crusader/pull/47)
    - #45: [bump mint from 1.3.0 to 1.4.0](https://github.com/jpcaruana/last_crusader/pull/45)
    - #41: [bump webmentions from 1.0.2 to 1.0.3](https://github.com/jpcaruana/last_crusader/pull/41)
    - #44: [bump plug_cowboy from 2.5.1 to 2.5.2](https://github.com/jpcaruana/last_crusader/pull/44)
        - telemetry: 0.4.3 -> 1.1.0
        - plug: 1.12.0 -> 1.12.1
        - cowboy_telemetry: 0.3.1 -> 0.4.0

## 0.6.x
### 0.6.4
2021/08/12
- fix: `LastCrusader.Micropub.add_keyword_to_post/2`: one integration test was missing (and an error crept in). I learned how powerful json decoding was with Tesla...
- dependencies update:
    - remove unused dependency on toml
    - remove unnecessary dependency on [Poison](https://github.com/devinus/poison) (we use [Jason](https://github.com/michalmuskala/jason) for json encoding/decoding from now on)
    - #34: [bump plug_cowboy from 2.5.0 to 2.5.1](https://github.com/jpcaruana/last_crusader/pull/34)
        - plug: 1.11.0 -> 1.12.0
        - cowlib: 2.9.1 -> 2.11.0
        - ranch: 1.7.1 -> 1.8.0
    - #37: [bump tz from 0.17.0 to 0.19.0](https://github.com/jpcaruana/last_crusader/pull/37)
    - #39: [bump tesla from 1.4.2 to 1.4.3](https://github.com/jpcaruana/last_crusader/pull/39)

### 0.6.1
2021/07/21
- investigation around automatic syndication: match `LastCrusader.Micropub.add_keyword_to_post/2` response
- some refactor/duplication hunting

### 0.6.0
2021/07/16: back syndication
- update post after automatic syndication via [brid.gy](https://brid.gy/):
    - find twitter syndication link in brid.gy's response
    - github:
      - retrieve a file's content
      - update a file
    - new `LastCrusader.Utils.Toml` module for light/easy Toml manipulation
- dependencies update:
    - #28: [bump webmentions from 1.0.1 to 1.0.2](https://github.com/jpcaruana/last_crusader/pull/28)
        - floki: 0.30.1 -> 0.31.0
    - #29: [bump tz from 0.16.2 to 0.17.0](https://github.com/jpcaruana/last_crusader/pull/29)
    - #30: [bump tesla from 1.4.1 to 1.4.2](https://github.com/jpcaruana/last_crusader/pull/30)
        - castore: 0.1.10 -> 0.1.11

## 0.5.x
### 0.5.4
2021/06/22
- dependencies update:
    - #14: [bump plug_cowboy from 2.4.1 to 2.5.0](https://github.com/jpcaruana/last_crusader/pull/14)
        - telemetry: 0.4.2 -> 0.4.3
    - #18/#20: [bump webmentions from 0.5.3 to 1.0.1](https://github.com/jpcaruana/last_crusader/pull/20) (with contributions from me)
    - #19/#21/#24: [bump tz from 0.12.0 to 0.16.2 ](https://github.com/jpcaruana/last_crusader/pull/24)
    - #22: [bump mint from 1.2.1 to 1.3.0](https://github.com/jpcaruana/last_crusader/pull/22)
- script to make a release that targets a debian: `./debian_release.sh` (uses docker)

### 0.5.3
2021/04/16
- micropub:
    - Hugo: fix links extraction from Hugo posts
    - Hugo: fix: treat `mp-syndicate-to` property as a `syndicate-to` one
    - webmention: add automatic syndication to twitter.com (via [brid.gy](https://brid.gy/))
    - better logs

### 0.5.0
2021/04/16
- micropub:
    - Hugo: support `like-of` types as Notes
    - Hugo: support `repost-of` types as Notes
- webmention: check if origin exists every minute with a `HEAD` HTTP request. It will prevent us from waiting too long for the content to be published

## 0.4.x
### 0.4.3
2021/04/14
- micropub:
    - Hugo: support `in-reply-to` types as Notes
    - webmention: add [brid.gy](https://brid.gy/) webmention endpoint for:
        - twitter.com
        - github.com
- dependencies update:
    - #11: [bump tesla from 1.4.0 to 1.4.1](https://github.com/jpcaruana/last_crusader/pull/11)
        - mime: 1.5.0 -> 1.6.0

### 0.4.0
2021/04/06
- drop support for Elixir < 1.11
- better handling of proxied HTTPS requests (see [Plug.RewriteOn](https://hexdocs.pm/plug/Plug.RewriteOn.html))
- CI: 
    - added doctor to check
    - added credo to check
- added as much Typespecs as possible
- dependencies update:
    - #10: [bump webmentions from 0.5.2 to 0.5.3](https://github.com/jpcaruana/last_crusader/pull/10)
    - remove dependency to timex: drop support to Elixir < 1.11

## 0.3.x
### 0.3.4
2021/03/04
- micropub/webmention: Handles my personal special case with my "indienews" Hugo shortcode

### 0.3.3
2021/03/02
- micropub: fix Github integration
- #5: dependencies: [bump timex from 3.6.3 to 3.6.4](https://github.com/jpcaruana/last_crusader/pull/5)
    - tzdata: 1.0.5 -> 1.1.0


### 0.3.2
2021/02/25
- micropub: 
    - fix encoding issues from another weird long dash (see also release 0.2.2)
    - extract links from bookmark posts for webmention
- dependencies: remove unnecessary dependency to Tentacat

### 0.3.1
2021/02/24
- added /status route for remote monitoring
- better logging configuration

### 0.3.0
2021/02/24
- micropub: send webmentions to mentionned URL in published content (waits for a publishing delay from Github/Netlify)

## 0.2.x
### 0.2.2
2021/02/11
- micropub: fix encoding issues from weird long dash
- dependencies update:
    - #3: [bump plug_cowboy from 2.3.0 to 2.4.1](https://github.com/jpcaruana/last_crusader/pull/3)
        - cowboy_telemetry: 0.3.1

### 0.2.1
2021/01/28
- micropub: fix encoding issues from emojis

### 0.2.0
2020/11/18
- First "production" release (lol)
