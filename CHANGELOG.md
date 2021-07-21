# Changelog

## Unreleased yet

## 0.6.1
2021/07/21
- investigation around automatic synndication: match `Micropub.add_keyword_to_post/2` response
- dependancies update:
    - #33: [bump ex_doc from 0.24.2 to 0.25.0](https://github.com/jpcaruana/last_crusader/pull/33)

## 0.6.0
2021/07/16
- update post after automatic syndication via [brid.gy](https://brid.gy/):
    - find twitter syndication link in brid.gy's response
    - github:
      - retrieve a file's content
      - update a file
    - new `LastCrusader.Utils.Toml` module for light/easy Toml manipulation
- dependancies update:
    - #28: [bump webmentions from 1.0.1 to 1.0.2](https://github.com/jpcaruana/last_crusader/pull/28)
    - #29: [bump tz from 0.16.2 to 0.17.0](https://github.com/jpcaruana/last_crusader/pull/29)
    - #30: [bump tesla from 1.4.1 to 1.4.2](https://github.com/jpcaruana/last_crusader/pull/30)
    - #31: [bump git_hooks from 0.6.2 to 0.6.3](https://github.com/jpcaruana/last_crusader/pull/31)

## 0.5.4
2021/06/22
- dependancies update:
    - #14: [bump plug_cowboy from 2.4.1 to 2.5.0](https://github.com/jpcaruana/last_crusader/pull/14)
    - #18/#20: [bump webmentions from 0.5.3 to 1.0.1](https://github.com/jpcaruana/last_crusader/pull/20) (with contributions from me)
    - #19/#21/#24: [bump tz from 0.12.0 to 0.16.2 ](https://github.com/jpcaruana/last_crusader/pull/24)
    - #22: [bump mint from 1.2.1 to 1.3.0](https://github.com/jpcaruana/last_crusader/pull/22)
    - #15/#16/#17: [bump git_hooks from 0.5.2 to 0.6.2](https://github.com/jpcaruana/last_crusader/pull/15)
    - #23: [bump mix_test_watch from 1.0.2 to 1.0.3](https://github.com/jpcaruana/last_crusader/pull/23)
    - #25: [bump excoveralls from 0.14.0 to 0.14.1](https://github.com/jpcaruana/last_crusader/pull/25)
    - #26: [bump credo from 1.5.5 to 1.5.6](https://github.com/jpcaruana/last_crusader/pull/26)
    - #27: [bump doctor from 0.17.0 to 0.18.0](https://github.com/jpcaruana/last_crusader/pull/27)
- script to make a release that targets a debian: `./debian_release.sh` (uses docker)

## 0.5.3
2021/04/16
- micropub:
    - Hugo: fix links extraction from Hugo posts
    - Hugo: fix: treat `mp-syndicate-to` property as a `syndicate-to` one
    - webmention: add automatic syndication to twitter.com (via [brid.gy](https://brid.gy/))
    - better logs

## 0.5.0
2021/04/16
- micropub:
    - Hugo: support `like-of` types as Notes
    - Hugo: support `repost-of` types as Notes
- webmention: check if origin exists every minute with a `HEAD` HTTP request. It will prevent us from waiting too long for the content to be published

## 0.4.3
2021/04/14
- micropub:
    - Hugo: support `in-reply-to` types as Notes
    - webmention: add [brid.gy](https://brid.gy/) webmention endpoint for:
        - twitter.com
        - github.com
- dependancies update:
    - #11: [bump ex_doc from 0.24.1 to 0.24.2](https://github.com/jpcaruana/last_crusader/pull/11)
    - #12: [bump tesla from 1.4.0 to 1.4.1](https://github.com/jpcaruana/last_crusader/pull/12)

## 0.4.0
2021/04/06
- drop support for Elixir < 1.11
- better handling of proxied HTTPS requests (see [Plug.RewriteOn](https://hexdocs.pm/plug/Plug.RewriteOn.html))
- CI: 
    - added doctor to check
    - added credo to check
- added as much Typespecs as possible
- dependancies update:
    - #6/#9: [bump ex_doc from 0.23.0 to 0.24.1](https://github.com/jpcaruana/last_crusader/pull/9)
    - #10: [bump webmentions from 0.5.2 to 0.5.3](https://github.com/jpcaruana/last_crusader/pull/10)
    - remove dependancy to timex: drop support to Elixir < 1.11

## 0.3.4
2021/03/04
- micropub/webmention: Handles my personal special case with my "indienews" Hugo shortcode

## 0.3.3
2021/03/02
- micropub: fix Github integration
- #5: dependancies: [bump timex from 3.6.3 to 3.6.4](https://github.com/jpcaruana/last_crusader/pull/5)

## 0.3.2
2021/02/25
- micropub: 
    - fix encoding issues from another weird long dash (see also release 0.2.2)
    - extract links from bookmark posts for webmention
- dependancies: remove unnecessary dependancy to Tentacat

## 0.3.1
2021/02/24
- added /status route for remote monitoring
- better logging configuration

## 0.3.0
2021/02/24
- micropub: send webmentions to mentionned URL in published content (waits for a publishing delay from Github/Netlify)
- #4: dependancies: [bump excoveralls from 0.13.4 to 0.14.0](https://github.com/jpcaruana/last_crusader/pull/4)

## 0.2.2
2021/02/11
- micropub: fix encoding issues from weird long dash
- dependancies update:
    - #3: [bump plug_cowboy from 2.3.0 to 2.4.1](https://github.com/jpcaruana/last_crusader/pull/3)
    - #1: [bump excoveralls from 0.12.3 to 0.13.4](https://github.com/jpcaruana/last_crusader/pull/1)

## 0.2.1
2021/01/28
- micropub: fix encoding issues from emojis

## 0.2.0
2020/11/18
- First "production" release

## 0.1.0
- Draft 
