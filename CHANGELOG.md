# Changelog

## 0.7.x
### 0.7.6
2022/02/25
- micropub: Hugo: avoid markdown 'quote' char (`>`) for filename generation
- dependancies update:
    - #74: [bump mint from 1.4.0 to 1.4.1](https://github.com/jpcaruana/last_crusader/pull/74)
        - added dep on hpax 0.1.1

### 0.7.5
2022/02/15
- micropub: Hugo: avoid hugo shortcode for twitter user for filename generation
- dependancies update:
    - #71: [bump hackney from 1.18.0 to 1.18.1](https://github.com/jpcaruana/last_crusader/pull/71)
        - certify: 2.8.0 -> 2.9.0
    - #72: [bump nimble_parsec from 1.2.1 to 1.2.2](https://github.com/jpcaruana/last_crusader/pull/72)

### 0.7.4
2022/02/02
- dependancies update:
    - #69: [bump castore from 0.1.14 to 0.1.15](https://github.com/jpcaruana/last_crusader/pull/69)
    - #67: [bump nimble_parsec from 1.2.0 to 1.2.1](https://github.com/jpcaruana/last_crusader/pull/67)

### 0.7.3
2022/01/20
- webapp: add `Plug.Cowboy.Drainer` for a cleaner shutdown
- debug mode: webmention sender: more logs
- dependancies update:
    - #62: [bump webmentions from 1.0.3 to 2.0.0](https://github.com/jpcaruana/last_crusader/pull/62)
        - floki: 0.31.0 -> 0.32.0

### 0.7.2
2021/12/22
- parse links from markdown: use [nimble parsec](https://hexdocs.pm/nimble_parsec/) instead of regex
    - Note: it adds a new dependancy to this (great) library
- dependancies update:
    - #59: [bump castore from 0.1.13 to 0.1.14](https://github.com/jpcaruana/last_crusader/pull/59)
    - #60: [bump tesla from 1.4.3 to 1.4.4](https://github.com/jpcaruana/last_crusader/pull/60)
        - mime: 1.6.0 -> 2.0.2
    - #61: [bump jason from 1.2.2 to 1.3.0](https://github.com/jpcaruana/last_crusader/pull/61)

### 0.7.1
2021/12/03
- micropub: fix date conversion to Hugo (respect the timezone)
    - removed comptatibility with Elixir < 1.12
- fix sentry necessary dependancies and install
- dependancies update:
    - #50/#55: [bump bump castore from 0.1.11 to 0.1.13](https://github.com/jpcaruana/last_crusader/pull/55)
    - #49: [bump sentry from 8.0.5 to 8.0.6](https://github.com/jpcaruana/last_crusader/pull/49)
        - certifi: 2.6.1 -> 2.8.0
        - hackney: 1.17.4 -> 1.18.0

### 0.7.0
2021/09/24
- added [sentry](https://sentry.io/) monitoring
- dependancies update:
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
- fix: `LastCrusader.Micropub.add_keyword_to_post/2`: one integration test was missing (and an error crept in). I learned how powerfull json decoding was with Tesla...
- dependancies update:
    - remove unused dependancy on toml
    - remove unnecessary dependancy on [Poison](https://github.com/devinus/poison) (we use [Jason](https://github.com/michalmuskala/jason) for json encoding/decoding from now on)
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
2021/07/16
- update post after automatic syndication via [brid.gy](https://brid.gy/):
    - find twitter syndication link in brid.gy's response
    - github:
      - retrieve a file's content
      - update a file
    - new `LastCrusader.Utils.Toml` module for light/easy Toml manipulation
- dependancies update:
    - #28: [bump webmentions from 1.0.1 to 1.0.2](https://github.com/jpcaruana/last_crusader/pull/28)
        - floki: 0.30.1 -> 0.31.0
    - #29: [bump tz from 0.16.2 to 0.17.0](https://github.com/jpcaruana/last_crusader/pull/29)
    - #30: [bump tesla from 1.4.1 to 1.4.2](https://github.com/jpcaruana/last_crusader/pull/30)
        - castore: 0.1.10 -> 0.1.11

## 0.5.x
### 0.5.4
2021/06/22
- dependancies update:
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
- dependancies update:
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
- dependancies update:
    - #10: [bump webmentions from 0.5.2 to 0.5.3](https://github.com/jpcaruana/last_crusader/pull/10)
    - remove dependancy to timex: drop support to Elixir < 1.11

## 0.3.x
### 0.3.4
2021/03/04
- micropub/webmention: Handles my personal special case with my "indienews" Hugo shortcode

### 0.3.3
2021/03/02
- micropub: fix Github integration
- #5: dependancies: [bump timex from 3.6.3 to 3.6.4](https://github.com/jpcaruana/last_crusader/pull/5)
    - tzdata: 1.0.5 -> 1.1.0


### 0.3.2
2021/02/25
- micropub: 
    - fix encoding issues from another weird long dash (see also release 0.2.2)
    - extract links from bookmark posts for webmention
- dependancies: remove unnecessary dependancy to Tentacat

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
- dependancies update:
    - #3: [bump plug_cowboy from 2.3.0 to 2.4.1](https://github.com/jpcaruana/last_crusader/pull/3)
        - cowboy_telemetry: 0.3.1

### 0.2.1
2021/01/28
- micropub: fix encoding issues from emojis

### 0.2.0
2020/11/18
- First "production" release (lol)

